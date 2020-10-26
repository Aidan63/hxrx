package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;

class Defer<T> implements IObservable<T>
{
    final factory : ()->IObservable<T>;

    public function new(_factory)
    {
        factory = _factory;
    }

    public function subscribe<E>(_observer : IObserver<T>)
    {
        final detaching    = new AutoDetachingObserver(_observer);
        final subscription = factory().subscribe(_observer);

        if (!detaching.isAlive())
        {
            subscription.unsubscribe();
        }

        return subscription;
    }
}