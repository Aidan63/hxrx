package hxrx.observables;

import hxrx.subscriptions.Empty;
import hxrx.observer.Observer;
import hxrx.observer.AutoDetachingObserver;
import hxrx.schedulers.IScheduler;

class ObserverOn<T> implements IObservable<T>
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
        final detaching = new AutoDetachingObserver(_observer);
        final observer  = new Observer(
            v -> scheduler.scheduleNow(_ -> {
                detaching.onNext(v);

                return new Empty();
            }),
            e -> scheduler.scheduleNow(_ -> {
                detaching.onError(e);

                return new Empty();
            }),
            () -> scheduler.scheduleNow(_ -> {
                detaching.onCompleted();

                return new Empty();
            }));
        final subscription = source.subscribe(observer);

        detaching.setSubscription(subscription);

        return subscription;
    }
}