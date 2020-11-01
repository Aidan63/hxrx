import haxe.Timer;
import haxe.MainLoop;
import hxrx.observables.ConnectableObservable;
import hxrx.subscriptions.Single;
import hxrx.IObserver;
import hxrx.IObservable;
import haxe.Exception;
import hxrx.observer.Observer;
import hxrx.observables.Observables;
import hxrx.subscriptions.Empty;

using hxrx.observables.Observables;

class RxTests
{
	static function main()
	{
		final observer = new Observer(v -> trace('value: $v'), e -> throw e, () -> trace('complete'));
		
		create(obs -> {
			obs.onNext('hello');
			obs.onNext('world');
			obs.onCompleted();

			return new Single(() -> trace('disposed'));
		}).synchronise().subscribe(observer);
		// create(obs -> {
		// 	obs.onNext('hello');
		// 	obs.onCompleted();

		// 	return new Single(() -> trace('disposed'));
		// }).subscribe(observer);

		// final observer   = new Observer((_v : Int) -> trace('subscription : $_v'), _e -> throw _e, () -> trace('done'));
		// final observable = range(0, 5).print().publish();
		// final s1 = observable.subscribe(observer);
		// final s2 = observable.subscribe(observer);
		// observable.connect();

		// trace('--');

		// s1.unsubscribe();
		// s2.unsubscribe();
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

		// create(obs -> {
		// 	for (i in 1...4)
		// 	{
		// 		obs.onNext(i);
		// 	}

		// 	obs.onCompleted();

		// 	return new Single(() -> trace('disposed'));
		// }).flatMap(v -> range(v, 3)).subscribe(observer);
		// range(1, 3).flatMap(x -> range(x, 3)).subscribe(observer);
	}
}
