package hxrx.observer;

import haxe.Exception;

class Observer<T> implements IObserver<T>
{
    final nextFunc : T->Void;

    final errorFunc : Exception->Void;

    final completeFunc : Void->Void;

	public function new(_next, _error, _complete)
	{
        nextFunc     = _next;
        errorFunc    = _error;
        completeFunc = _complete;
	}

	public function onNext(_value : T)
	{
		nextFunc(_value);
	}

	public function onError(_value : Exception)
	{
		errorFunc(_value);
	}

	public function onCompleted()
	{
		completeFunc();
	}
}