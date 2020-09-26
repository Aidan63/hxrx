package hxrx.observables;

class Defer<T> implements IObservable<T>
{
    final factory : ()->IObservable<T>;

    public function new(_factory)
    {
        factory = _factory;
    }

    public function subscribe<E>(_observer : IObserver<T>)
    {
        return factory().subscribe(_observer);
    }
}