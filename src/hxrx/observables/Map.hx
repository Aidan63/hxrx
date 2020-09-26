package hxrx.observables;

import hxrx.observer.Observer;

class Map<T, E> implements IObservable<E>
{
    final source : IObservable<T>;

    final func : T->E;

    public function new(_source, _func)
    {
        source = _source;
        func   = _func;
    }

    public function subscribe(_observer : IObserver<E>)
    {
        return source.subscribe(new Observer(_value -> _observer.onNext(func(_value)), _observer.onError, _observer.onCompleted));
    }
}