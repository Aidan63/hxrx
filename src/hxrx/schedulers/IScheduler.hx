package hxrx.schedulers;

interface IScheduler
{
    function time() : Float;

    function scheduleNow(_task : (_scheduler : IScheduler)->ISubscription) : ISubscription;

    function scheduleIn(_dueTime : Float, _task : (_scheduler : IScheduler)->ISubscription) : ISubscription;

    function scheduleAt(_dueTime : Date, _task : (_scheduler : IScheduler)->ISubscription) : ISubscription;
}