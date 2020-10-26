package observables;

import haxe.Exception;
import buddy.BuddySuite;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import hxrx.observables.Observables;

using hxrx.observables.Observables;
using buddy.Should;

class MapTests extends BuddySuite
{
    public function new()
    {
        describe('Map', {
            describe('Successful Observable', {
                var done = false;

                final output   = [];
                final observer = new Observer(v -> output.push(v), e -> fail(e), null);

                create(o -> {
                    for (i in 1...4)
                    {
                        o.onNext(i);
                    }

                    o.onCompleted();

                    return new Single(() -> done = true);
                }).map(v -> '$v').subscribe(observer);

                it('will transform a sequence into another type', {
                    output.should.containExactly([ '1', '2', '3' ]);
                });

                it('will automatically dispose of the subscription when the observable completes', {
                    done.should.be(true);
                });
            });
            describe('Failing Observable', {
                var done = false;

                final output = [];
                final observer = new Observer(v -> output.push(v), null, null);

                create(o -> {
                    o.onNext(1);
                    o.onError(new Exception('stopping'));
                    o.onNext(2);

                    return new Single(() -> done = true);
                }).map(v -> '$v').subscribe(observer);

                it('will transform a sequence into another type', {
                    output.should.containExactly([ '1' ]);
                });

                it('will automatically dispose of the subscription when the observable completes', {
                    done.should.be(true);
                });
            });
        });
    }
}