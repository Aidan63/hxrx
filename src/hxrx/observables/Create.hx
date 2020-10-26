package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;

class Create<T> implements IObservable<T>
{
    final func : (_observer : IObserver<T>)->ISubscription;

    public function new(_func)
    {
        func = _func;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = func(detaching);

        if (!detaching.isAlive())
        {
            subscription.unsubscribe();
        }

        return subscription;
    }
}