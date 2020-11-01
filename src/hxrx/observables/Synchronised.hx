package hxrx.observables;

import hxrx.observer.Observer;
import hxrx.observer.AutoDetachingObserver;
import haxe.Exception;
import sys.thread.Mutex;

class Synchronised<T> implements IObservable<T>
{
    final source : IObservable<T>;

    final mutex : Mutex;

    public function new(_source)
    {
        source = _source;
        mutex  = new Mutex();
    }

    public function subscribe(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final locking      = new Observer(v -> next(detaching, v), e -> error(detaching, e), () -> complete(detaching));
        final subscription = source.subscribe(locking);

        if (!detaching.isAlive())
        {
            subscription.unsubscribe();
        }

        return subscription;
    }

    function next(_observer : IObserver<T>, _value : T)
    {
        mutex.acquire();
        _observer.onNext(_value);
        mutex.release();
    }

    function error(_observer : IObserver<T>, _error : Exception)
    {
        mutex.acquire();
        _observer.onError(_error);
        mutex.release();
    }

    function complete(_observer : IObserver<T>)
    {
        mutex.acquire();
        _observer.onCompleted();
        mutex.release();
    }
}