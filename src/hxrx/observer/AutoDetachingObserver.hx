package hxrx.observer;

import haxe.Exception;

class AutoDetachingObserver<T> implements IObserver<T>
{
    final observer : IObserver<T>;

    var subscription : Null<ISubscription>;

    var disposed : Bool;

    public function new(_observer)
    {
        observer     = _observer;
        subscription = null;
        disposed     = false;
    }

    public function setSubscription(_subscription)
    {
        if (subscription == null)
        {
            subscription = _subscription;
        }
        if (disposed)
        {
            subscription.unsubscribe();
        }
    }

	public function onNext(_value : T)
    {
        if (disposed)
        {
            return;
        }

        try
        {
            observer.onNext(_value);
        }
        catch (_)
        {
            unsubscribe();
        }
    }

    public function onError(_value : Exception)
    {
        if (disposed)
        {
            return;
        }

        observer.onError(_value);

        unsubscribe();
    }

    public function onCompleted()
    {
        if (disposed)
        {
            return;
        }
        
        observer.onCompleted();

        unsubscribe();
    }

    function unsubscribe()
    {
        if (disposed)
        {
            return;
        }

        if (subscription != null)
        {
            subscription.unsubscribe();
        }

        disposed = true;
    }
}