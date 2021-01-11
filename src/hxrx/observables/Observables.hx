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
    return create(_observer -> _factory().subscribe(_observer));
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
    return create(_observer -> {
        for (i in _min..._max + 1)
        {
            _observer.onNext(i);
        }

        _observer.onCompleted();

        return new Empty();
    });
}

function fromIterator<T>(_iterable : Iterator<T>)
{
    return create(_observer -> {
        for (v in _iterable)
        {
            _observer.onNext(v);
        }

        _observer.onCompleted();

        return new Empty();
    });
}

function fromIterable<T>(_iterable : Iterable<T>)
{
    return fromIterator(_iterable.iterator());
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

function filter<T>(_source : IObservable<T>, _func : (_value : T)->Bool) : IObservable<T>
{
    return new Filter(_source, _func);
}

// Utility



// Conditional and Boolean



// Mathematical and Aggregate



// Connect

function publish<T>(_source : IObservable<T>) : IConnectableObservable<T>
{
    return new ConnectableObservable(_source);
}

function refCount<T>(_source : IConnectableObservable<T>) : IObservable<T>
{
    return new RefCount(_source);
}

// Threading

function synchronise<T>(_source : IObservable<T>) : IObservable<T>
{
    return new Synchronised(_source);
}

function subscribeOn<T>(_source : IObservable<T>, _scheduler : IScheduler) : IObservable<T>
{
    return new SubscribeOn(_source, _scheduler);
}

function observeOn<T>(_source : IObservable<T>, _scheduler : IScheduler) : IObservable<T>
{
    return new ObserverOn(_source, _scheduler);
}