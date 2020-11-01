package hxrx.schedulers;

interface IScheduler
{
    function time() : Float;

    function schedule(_task : ()->Void) : ISubscription;

    function scheduleRelative(_task : ()->Void, _time : Float) : ISubscription;

    function scheduleAbsolute(_task : ()->Void, _date : Date) : ISubscription;
}