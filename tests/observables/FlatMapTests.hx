package observables;

import haxe.Exception;
import buddy.BuddySuite;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import hxrx.observables.Observables;

using hxrx.observables.Observables;
using buddy.Should;

class FlatMapTests extends BuddySuite
{
    public function new()
    {
        describe('FlatMap', {
            describe('Successful Observable', {
                var done = false;
                var accu = 0;
    
                final observer = new Observer(v -> accu += v, null, null);
    
                create(o -> {
                    for (i in 1...4)
                    {
                        o.onNext(i);
                    }
    
                    o.onCompleted();
    
                    return new Single(() -> done = true);
                }).flatMap(v -> range(1, v)).subscribe(observer);
    
                it('will pipe all child observable values into the observer', {
                    final expected = 1 + 2 + 3 + 1 + 2 + 1;
    
                    accu.should.be(expected);
                });
    
                it('will dispose of the subscription once all child observables have completed', {
                    done.should.be(true);
                });
            });
            describe('Failing Observable', {
                var done = false;
                var accu = 0;
    
                final observer = new Observer(v -> accu += v, null, null);
    
                create(o -> {
                    for (i in 1...4)
                    {
                        if (i == 3)
                        {
                            o.onError(new Exception('stopping'));
                        }
                        else
                        {
                            o.onNext(i);
                        }
                    }
    
                    o.onCompleted();
    
                    return new Single(() -> done = true);
                }).flatMap(v -> range(1, v)).subscribe(observer);
    
                it('will pipe all child observable values into the observer', {
                    final expected = 1 + 1 + 2;
    
                    accu.should.be(expected);
                });
    
                it('will dispose of the subscription once all child observables have completed', {
                    done.should.be(true);
                });
            });
        });
    }
}