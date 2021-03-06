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
                var disposed  = false;
                var completed = 0;
                var errored   = 0;
                var accu      = 0;
    
                final observer = new Observer(v -> accu += v, _ -> errored += 1, () -> completed += 1);
    
                create(o -> {
                    for (i in 1...4)
                    {
                        o.onNext(i);
                    }
    
                    o.onCompleted();
    
                    return new Single(() -> disposed = true);
                }).flatMap(v -> range(1, v)).subscribe(observer);
    
                it('will pipe all child observable values into the observer', {
                    final expected = 1 + 2 + 3 + 1 + 2 + 1;
    
                    accu.should.be(expected);
                });
                it('will dispose of the subscription once all child observables have completed', {
                    disposed.should.be(true);
                });
                it('will have called the onCompleted function of the observer once', {
                    completed.should.be(1);
                });
                it('will not have called the onError function of the observer', {
                    errored.should.be(0);
                });
            });
            describe('Failing Observable', {
                var disposed  = false;
                var completed = 0;
                var errored   = 0;
                var accu      = 0;
    
                final observer = new Observer(v -> accu += v, _ -> errored += 1, () -> completed += 1);
    
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
    
                    return new Single(() -> disposed = true);
                }).flatMap(v -> range(1, v)).subscribe(observer);
    
                it('will pipe all child observable values into the observer', {
                    final expected = 1 + 1 + 2;
    
                    accu.should.be(expected);
                });
                it('will dispose of the subscription once all child observables have completed', {
                    disposed.should.be(true);
                });
                it('will have called the onError function of the observer once', {
                    errored.should.be(1);
                });
                it('will not have called the onComplete function of the observer', {
                    completed.should.be(0);
                });
            });
        });
    }
}