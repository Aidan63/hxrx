package observables;

import hxrx.subscriptions.Empty;
import haxe.Exception;
import buddy.BuddySuite;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import hxrx.observables.Observables;

using hxrx.observables.Observables;
using buddy.Should;

class RefCountTests extends BuddySuite
{
    public function new()
    {
        describe('RefCount', {
            it('will connect to the source observable when the first observer subscruibes', {
                var disposed = false;
                var counter  = 0;

                final expected  = 3;
                final observer  = new Observer(v -> counter += v, e -> throw e, null);
                final published = create(obs -> {
                    obs.onNext(1);
                    obs.onNext(2);
                    obs.onCompleted();

                    return new Single(() -> disposed = true);
                }).publish().refCount();

                disposed.should.be(false);
                counter.should.be(0);

                published.subscribe(observer);

                disposed.should.be(true);
                counter.should.be(expected);
            });
        });
    }
}