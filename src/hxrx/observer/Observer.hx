package hxrx.observer;

import haxe.Exception;

class Observer<T> implements IObserver<T>
{
    final nextFunc : Null<T->Void>;

    final errorFunc : Null<Exception->Void>;

    final completeFunc : Null<Void->Void>;

	public function new(_next, _error, _complete)
	{
        nextFunc     = _next;
        errorFunc    = _error;
        completeFunc = _complete;
	}

	public function onNext(_value : T)
	{
		if (nextFunc != null)
		{
			nextFunc(_value);
		}
	}

	public function onError(_value : Exception)
	{
		if (errorFunc != null)
		{
			errorFunc(_value);
		}
	}

	public function onCompleted()
	{
		if (completeFunc != null)
		{
			completeFunc();
		}
	}
}