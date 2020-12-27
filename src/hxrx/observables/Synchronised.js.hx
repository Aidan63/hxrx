package hxrx.observables;

import hxrx.observer.Observer;
import hxrx.observer.AutoDetachingObserver;
import haxe.Exception;

class Synchronised<T> implements IObservable<T>
{
    final source : IObservable<T>;

    public function new(_source)
    {
        source = _source;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = source.subscribe(detaching);

        detaching.setSubscription(subscription);

        return subscription;
    }
}