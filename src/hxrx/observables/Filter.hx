package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.observer.Observer;

class Filter<T> implements IObservable<T>
{
    final source : IObservable<T>;

    final func : T->Bool;

    public function new(_source, _func)
    {
        source = _source;
        func   = _func;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = source.subscribe(new Observer(_value -> {
            if (func(_value))
            {
                detaching.onNext(_value);
            }
        }, detaching.onError, detaching.onCompleted));

        detaching.setSubscription(subscription);

        return subscription;
    }
}