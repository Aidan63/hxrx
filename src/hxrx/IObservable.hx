package hxrx;

interface IObservable<T>
{
    function subscribe(_observer : IObserver<T>) : ISubscription;
}