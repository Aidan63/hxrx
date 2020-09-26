package hxrx.observables;

import haxe.Exception;
import hxrx.subscriptions.Empty;

// Create

function create<T>(_func : (_observer : IObserver<T>)->ISubscription)
{
    return new Create(_func);
}

function defer<T>(_factory : ()->IObservable<T>)
{
    return new Defer(_factory);
}

function empty()
{
    return create(_observer -> {
        _observer.onCompleted();
        return new Empty();
    });
}

function never()
{
    return create(_observer -> new Empty());
}

function error(_error : Exception)
{
    return create(_observer -> {
        _observer.onError(_error);
        return new Empty();
    });
}

function range(_min : Int, _max : Int)
{
    return new Range(_min, _max);
}

function interval(_time : Float)
{
    return new TimerInterval(_time);
}

// Transform

function map<T, E>(_source : IObservable<T>, _func : T -> E) : IObservable<E>
{
    return new Map(_source, _func);
}

function scan<T, E>(_source : IObservable<T>, _seed : E, _func : (_acc : E, _v : T)->E) : IObservable<E>
{
    return new Scan(_source, _seed, _func);
}

function flatMap<T, E>(_source : IObservable<T>, _func : (_value : T)->IObservable<E>) : IObservable<E>
{
    return new FlatMap(_source, _func);
}

// Filter



// Utility

function print<T>(_source : IObservable<T>) : IObservable<T>
{
    return new Print(_source);
}

// Conditional and Boolean



// Mathematical and Aggregate



// Connect

function publish<T>(_source : IObservable<T>) : IConnectableObservable<T>
{
    return new ConnectableObservable(_source);
}
