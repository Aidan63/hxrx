package hxrx.schedulers;

class ScheduledItem implements ISubscription
{
    final scheduler : IScheduler;

    final task : (_scheduler : IScheduler) -> Void;

    public var cancelled (default, null) : Bool;

    public final dueTime : Float;

    public function new(_scheduler, _task, _dueTime)
    {
        task      = _task;
        scheduler = _scheduler;
        cancelled = false;
        dueTime   = _dueTime;
    }

    public function invoke()
    {
        task(scheduler);
    }

    public function unsubscribe()
    {
        cancelled = true;
    }
}