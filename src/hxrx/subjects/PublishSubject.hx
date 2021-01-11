package hxrx.subjects;

import hxrx.subscriptions.Empty;
import hxrx.subscriptions.Single;
import haxe.Exception;

class PublishSubject<T> implements IObservable<T> implements IObserver<T>
{
    final observers : Array<IObserver<T>>;

    var completed : Bool;

    var error : Exception;

    public function new()
    {
        observers = [];
        completed = false;
        error     = null;
    }

    public function onNext(_value : T)
    {
        if (completed)
        {
            return;
        }

        for (observer in observers)
        {
            observer.onNext(_value);
        }
    }

    public function onError(_error : Exception)
    {
        for (observer in observers)
        {
            observer.onError(_error);
        }

        observers.resize(0);

        completed = true;
        error     = _error;
    }

    public function onCompleted()
    {
        for (observer in observers)
        {
            observer.onCompleted();
        }

        observers.resize(0);

        completed = true;
    }

    public function subscribe(_observer : IObserver<T>) : ISubscription
    {
        if (!completed)
        {
            observers.push(_observer);

            return new Single(() -> observers.remove(_observer));
        }
        else
        {
            if (error != null)
            {
                _observer.onError(error);

                return new Empty();
            }
            else
            {
                _observer.onCompleted();

                return new Empty();
            }
        }
    }
}