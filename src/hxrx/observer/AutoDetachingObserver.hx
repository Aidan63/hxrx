package hxrx.observer;

import haxe.Exception;

class AutoDetachingObserver<T> implements IObserver<T>
{
    final child : IObserver<T>;

    var alive : Bool;

    public var subscription : Null<ISubscription>;

    public function new(_child)
    {
        child = _child;
        alive = true;
    }

	public function onNext(_value : T)
    {
        if (alive)
        {
            child.onNext(_value);
        }
    }

    public function onError(_value : Exception)
    {
        if (alive)
        {
            child.onError(_value);

            unsubscribe();

            alive = false;
        }
    }

    public function onCompleted()
    {
        if (alive)
        {
            child.onCompleted();

            unsubscribe();

            alive = false;
        }
    }

    public function isAlive()
    {
        return alive;
    }

    function unsubscribe()
    {
        if (subscription != null)
        {
            subscription.unsubscribe();
        }
    }
}