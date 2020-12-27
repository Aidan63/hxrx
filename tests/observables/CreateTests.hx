package observables;

import haxe.Exception;
import hxrx.observer.Observer;
import hxrx.observables.Create;
import hxrx.subscriptions.Single;
import buddy.BuddySuite;

using buddy.Should;

class CreateTests extends BuddySuite
{
    public function new()
    {
        describe('Create', {
            describe('Successful Observable', {
                var completed = false;
                var disposed  = false;
                var counted   = 0;

                new Create(observer -> {
                    observer.onNext(1);
                    observer.onNext(2);
                    observer.onNext(3);
                    observer.onCompleted();
                    observer.onNext(4);

                    return new Single(() -> disposed = true);
                }).subscribe(new Observer(v -> counted += v, e -> throw e, () -> completed = true));

                it('will have ran the provided function on subscription', {
                    counted.should.be(6);
                });
                it('will have called dispose on the subscription', {
                    disposed.should.be(true);
                });
                it('will call onComplete on the observable when completing the stream', {
                    completed.should.be(true);
                });
            });

            describe('Failing Observable', {
                var completed = false;
                var disposed  = false;
                var counted   = 0;
                var error     = new Exception('');

                new Create(observer -> {
                    observer.onNext(1);
                    observer.onNext(2);
                    observer.onNext(3);
                    observer.onError(new Exception('failed'));
                    observer.onNext(4);

                    return new Single(() -> disposed = true);
                }).subscribe(new Observer(v -> counted += v, e -> error = e, () -> completed = true));

                it('will have ran the provided function on subscription', {
                    counted.should.be(6);
                });
                it('will have called dispose on the subscription', {
                    disposed.should.be(true);
                });
                it('will not have aclled onComplete on the observable', {
                    completed.should.be(false);
                });
                it('will have passed the exception into the onError on the observable', {
                    error.message.should.be('failed');
                });
            });
        });
    }
}