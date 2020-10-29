package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.observer.Observer;

class FlatMap<T, E> implements IObservable<E>
{
    final source : IObservable<T>;

    final func : (_next : T)->IObservable<E>;

    public function new(_source, _func)
    {
        source = _source;
        func   = _func;
    }

    public function subscribe(_observer : IObserver<E>) : ISubscription
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final child        = new Observer(detaching.onNext, detaching.onError, null);
        final subscription = source.subscribe(new Observer(v -> func(v).subscribe(child), detaching.onError, detaching.onCompleted));

        if (!detaching.isAlive())
        {
            subscription.unsubscribe();
        }

        return subscription;
    }
}