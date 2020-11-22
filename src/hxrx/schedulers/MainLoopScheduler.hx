package hxrx.schedulers;

import hxrx.subscriptions.Single;
import haxe.Timer;

class MainLoopScheduler implements IScheduler
{
    public function new()
    {
        //
    }

    public function time() return Timer.stamp();

    public function scheduleNow(_task : (_scheduler : IScheduler) -> ISubscription)
    {
        return scheduleIn(0, _task);
    }

    public function scheduleAt(_dueTime : Date, _task : (_scheduler : IScheduler) -> ISubscription)
    {
        final diff = _dueTime.getTime() - Date.now().getTime();

        return scheduleIn(diff / 1000, _task);
    }

    public function scheduleIn(_dueTime : Float, _task : (_scheduler : IScheduler) -> ISubscription)
    {
        final timer = Timer.delay(() -> _task(this), Std.int(_dueTime * 1000));

        return new Single(() -> timer.stop());
    }
}