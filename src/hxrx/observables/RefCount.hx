package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.subscriptions.Single;
import hxrx.subscriptions.Composite;

class RefCount<T> implements IObservable<T>
{
    final source : IConnectableObservable<T>;

    var sourceSubscription : ISubscription;

    var references : Int;

    public function new(_source)
    {
        source     = _source;
        references = 0;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = source.subscribe(_observer);
        final composite    = new Composite([ subscription, new Single(decrementReference) ]);

        detaching.setSubscription(composite);

        if (references == 0)
        {
            sourceSubscription = source.connect();
        }

        references++;

        return composite;
    }

    function decrementReference()
    {
        references--;

        if (references == 0)
        {
            sourceSubscription.unsubscribe();
        }
    }
}