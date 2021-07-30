package hxrx.schedulers;

import hxrx.subscriptions.Empty;

interface IScheduler
{
    function time() : Float;

    function scheduleNow(_task : (_scheduler : IScheduler)->ISubscription) : ISubscription;

    function scheduleIn(_dueTime : Float, _task : (_scheduler : IScheduler)->ISubscription) : ISubscription;

    function scheduleAt(_dueTime : Date, _task : (_scheduler : IScheduler)->ISubscription) : ISubscription;
}

overload extern inline function scheduleFunction(_source : IScheduler, _function : Void->Void)
{
    return _source.scheduleNow(_ -> {
        _function();

        return new Empty();
    });
}

overload extern inline function scheduleFunction(_source : IScheduler, _dueTime : Float, _function : Void->Void)
{
    return _source.scheduleIn(_dueTime, _ -> {
        _function();

        return new Empty();
    });
}

overload extern inline function scheduleFunction(_source : IScheduler, _dueTime : Date, _function : Void->Void)
{
    return _source.scheduleAt(_dueTime, _ -> {
        _function();

        return new Empty();
    });
}