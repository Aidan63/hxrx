package hxrx.observables;

import hxrx.subscriptions.Single;
import haxe.Timer;

class TimerInterval implements IObservable<Int>
{
    final interval : Float;

    public function new(_interval)
    {
        interval = _interval;
    }

    public function subscribe(_observer : IObserver<Int>) : ISubscription
    {
        final ms    = Std.int(interval * 1000);
        final timer = new Timer(ms);

        timer.run = () -> _observer.onNext(ms);

        return new Single(timer.stop);
    }
}