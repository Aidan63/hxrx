package hxrx;

import haxe.Exception;

interface IObserver<T>
{
    function onNext(_value : T) : Void;

    function onError(_value : Exception) : Void;

    function onCompleted() : Void;
}