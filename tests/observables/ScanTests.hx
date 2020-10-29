package observables;

import haxe.Exception;
import buddy.BuddySuite;
import hxrx.observer.Observer;
import hxrx.subscriptions.Single;
import hxrx.observables.Observables;

using hxrx.observables.Observables;
using buddy.Should;

class ScanTests extends BuddySuite
{
    public function new()
    {
        describe('Scan', {
            describe('Successful Observable', {
                var disposed  = false;
                var completed = 0;
                var errored   = 0;
                
                final output   = [];
                final observer = new Observer(v -> output.push(v), _ -> errored += 1, () -> completed += 1);

                create(o -> {
                    o.onNext('h');
                    o.onNext('e');
                    o.onNext('l');
                    o.onNext('l');
                    o.onNext('o');
                    o.onNext('!');
                    o.onCompleted();

                    return new Single(() -> disposed = true);
                }).scan(2, (acc, next) -> acc + 1).subscribe(observer);

                it('will output the accumulated value every time it changes', {
                    output.should.containExactly([ 3, 4, 5, 6, 7, 8 ]);
                });
                it('will automatically dispose of the subscription when the observable completes', {
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
                
                final output   = [];
                final observer = new Observer(v -> output.push(v), _ -> errored += 1, () -> completed += 1);

                create(o -> {
                    o.onNext('h');
                    o.onNext('e');
                    o.onNext('l');
                    o.onNext('l');
                    o.onNext('o');
                    o.onNext('!');
                    o.onError(new Exception('stopping'));

                    return new Single(() -> disposed = true);
                }).scan(2, (acc, next) -> acc + 1).subscribe(observer);

                it('will output the accumulated value every time it changes', {
                    output.should.containExactly([ 3, 4, 5, 6, 7, 8 ]);
                });
                it('will automatically dispose of the subscription when the observable completes', {
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