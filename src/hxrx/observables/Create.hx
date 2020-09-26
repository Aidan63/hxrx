package hxrx.observables;

class Create<T, E> implements IObservable<T>
{
    final func : (_observer : IObserver<T>)->ISubscription;

    public function new(_func)
    {
        func = _func;
    }

    public function subscribe(_observer : IObserver<T>)
    {
        return func(_observer);
    }
}