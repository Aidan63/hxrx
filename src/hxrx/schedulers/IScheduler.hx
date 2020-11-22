package hxrx.schedulers;

interface IScheduler
{
    function time() : Float;

    function schedule(_task : (_scheduler : IScheduler)->ISubscription, _time : Float) : ISubscription;
}