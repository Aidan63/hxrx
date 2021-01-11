package hxrx.observables;

import hxrx.observer.AutoDetachingObserver;
import hxrx.schedulers.IScheduler;

class SubscribeOn<T> implements IObservable<T>
{
    final source : IObservable<T>;

    final scheduler : IScheduler;

    public function new(_source, _scheduler)
    {
        source    = _source;
        scheduler = _scheduler;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        return scheduler.scheduleNow(_ -> {
            final detaching    = new AutoDetachingObserver(_observer);
            final subscription = source.subscribe(detaching);

            detaching.setSubscription(subscription);

            return subscription;
        });
    }
}