package hxrx.observables;

import hxrx.subscriptions.Empty;

class Range implements IObservable<Int>
{
    final min : Int;

    final max : Int;

    public function new(_min, _max)
    {
        min = _min;
        max = _max;
    }

    public function subscribe(_observer : IObserver<Int>) : ISubscription
    {
        for (i in min...max + 1)
        {
            _observer.onNext(i);
        }

        _observer.onCompleted();

        return new Empty();
    }
}