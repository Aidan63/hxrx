import hxrx.IObserver;
import hxrx.IObservable;
import haxe.Exception;
import hxrx.observer.Observer;
import hxrx.observables.Observables;
import hxrx.subscriptions.Empty;

using hxrx.observables.Observables;

class Main
{
	static function main()
	{
		final observer   = new Observer((_v : Int) -> trace('subscription : $_v'), _e -> throw _e, () -> trace('done'));

		// final observable = interval(2.5).print().publish();
		// observable.subscribe(observer);
		// observable.subscribe(observer);
		// observable.connect();

		// create(_observer -> {
		// 	if (Math.random() >= 0.25)
		// 	{
		// 		_observer.onNext('greater or equal to 0.5');
		// 		_observer.onCompleted();
		// 	}
		// 	else
		// 	{
		// 		_observer.onError(new Exception('Less than 0.5'));
		// 	}

		// 	return new Empty();
		// }).map(_str -> _str.length).subscribe(observer);

		// range(1, 3).flatMap(x -> range(x, 3)).subscribe(observer);
	}
}
