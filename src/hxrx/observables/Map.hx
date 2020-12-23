package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.observer.Observer;

class Map<T, E> implements IObservable<E>
{
    final source : IObservable<T>;

    final func : T->E;

    public function new(_source, _func)
    {
        source = _source;
        func   = _func;
    }

    public function subscribe(_observer : IObserver<E>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = source.subscribe(new Observer(_value -> detaching.onNext(func(_value)), detaching.onError, detaching.onCompleted));

        detaching.setSubscription(subscription);

        return subscription;
    }
}