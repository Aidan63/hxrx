package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import haxe.ds.List;

class ConnectableObservable<T> implements IConnectableObservable<T>
{
    final source : IObservable<T>;

    final observers : List<IObserver<T>>;

    public function new(_source)
    {
        source    = _source;
        observers = new List();
    }

    public function subscribe(_observer : IObserver<T>) : ISubscription
    {
        observers.add(_observer);

        return new Single(remove.bind(_observer));
    }

    public function connect() : ISubscription
    {
        final detaching    = new AutoDetachingObserver(new Observer(onNextObservers, onErrorObservers, onCompleteObservers));
        final subscription = source.subscribe(detaching);

        detaching.setSubscription(subscription);

        return subscription;
    }

    function remove(_observer : IObserver<T>)
    {
        observers.remove(_observer);
    }

    function onNextObservers(_value)
    {
        for (o in observers)
        {
            o.onNext(_value);
        }
    }

    function onErrorObservers(_exception)
    {
        for (o in observers)
        {
            o.onError(_exception);
        }
    }

    function onCompleteObservers()
    {
        for (o in observers)
        {
            o.onCompleted();
        }
    }
}