package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.observer.Observer;

class Scan<T, E> implements IObservable<E>
{
    final source : IObservable<T>;

    final func : (_acc : E, _next : T)->E;

    var accumulated : E;

    public function new(_source, _seed, _func)
    {
        source      = _source;
        accumulated = _seed;
        func        = _func;
    }

    public function subscribe(_observer : IObserver<E>) : ISubscription
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = source.subscribe(new Observer(_value -> detaching.onNext(accumulated = func(accumulated, _value)), detaching.onError, detaching.onCompleted));

        detaching.setSubscription(subscription);
        
        return subscription;
    }
}