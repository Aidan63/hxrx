package hxrx;

interface IConnectableObservable<T> extends IObservable<T>
{
    function connect() : ISubscription;
}