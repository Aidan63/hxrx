package hxrx.observables;

import hxrx.observer.Observer;

class FlatMap<T, E> implements IObservable<E>
{
    final source : IObservable<T>;

    final func : (_next : T)->IObservable<E>;

    public function new(_source, _func)
    {
        source = _source;
        func   = _func;
    }

    public function subscribe(_observer : IObserver<E>) : ISubscription
    {
        return source.subscribe(new Observer(_next -> func(_next).subscribe(_observer), _observer.onError, _observer.onCompleted));
    }
}