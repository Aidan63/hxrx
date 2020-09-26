package hxrx.observables;

import haxe.Exception;

class Print<T> implements IObservable<T>
{
    final source : IObservable<T>;

    public function new(_source)
    {
        source = _source;
    }

    public function subscribe(_observer : IObserver<T>) : ISubscription
    {
        return source.subscribe(new TraceObserver(_observer));
    }
}

private class TraceObserver<T> implements IObserver<T>
{
    final forward : IObserver<T>;

    public function new(_forward)
    {
        forward = _forward;
    }

    public function onNext(_next : T)
    {
        trace(_next);

        forward.onNext(_next);
    }

    public function onError(_error : Exception)
    {
        forward.onError(_error);
    }

    public function onCompleted()
    {
        forward.onCompleted();
    }
}