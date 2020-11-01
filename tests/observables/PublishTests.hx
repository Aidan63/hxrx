package observables;

import haxe.Exception;
import buddy.BuddySuite;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import hxrx.observables.Observables;

using hxrx.observables.Observables;
using buddy.Should;

class PublishTests extends BuddySuite
{
    public function new()
    {
        describe('Publish', {
            it('will allow multiple observers to subscribe', {
                final observable = range(0, 5).publish();
                observable.subscribe(new Observer(null, null, null));
                observable.subscribe(new Observer(null, null, null));
            });
            it('will not start the sequence until connect is called', {
                final output1 = [];
                final output2 = [];

                final observable = range(0, 5).publish();
                observable.subscribe(new Observer(output1.push, null, null));
                observable.subscribe(new Observer(output2.push, null, null));

                output1.should.containExactly([]);
                output2.should.containExactly([]);

                observable.connect();

                output1.should.containExactly([ 0, 1, 2, 3, 4, 5 ]);
                output2.should.containExactly([ 0, 1, 2, 3, 4, 5 ]);
            });
            it('will dispose of the connection subscription when the source completes', {
                var disposed = false;

                create(obs -> {
                    obs.onCompleted();
                    return new Single(() -> disposed = true);
                }).publish().connect();

                disposed.should.be(true);
            });
            it('will dispose of all observers subscriptions when the source errors', {
                var disposed = false;

                create(obs -> {
                    obs.onError(new Exception('stopping'));
                    return new Single(() -> disposed = true);
                }).publish().connect();

                disposed.should.be(true);
            });
            it('will remove subscribers when the subscription is disposed of', {
                final output1    = [];
                final output2    = [];
                final observable = range(0, 5).publish();

                final subscription1 = observable.subscribe(new Observer(output1.push, null, null));
                observable.subscribe(new Observer(output2.push, null, null));

                output1.should.containExactly([]);
                output2.should.containExactly([]);

                observable.connect();

                output1.should.containExactly([ 0, 1, 2, 3, 4, 5 ]);
                output2.should.containExactly([ 0, 1, 2, 3, 4, 5 ]);

                subscription1.unsubscribe();

                observable.connect();

                output1.should.containExactly([ 0, 1, 2, 3, 4, 5 ]);
                output2.should.containExactly([ 0, 1, 2, 3, 4, 5, 0, 1, 2, 3, 4, 5 ]);
            });
        });
    }
}