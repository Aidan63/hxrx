package observer;

import haxe.Exception;
import hxrx.observer.Observer;
import hxrx.observer.AutoDetachingObserver;
import hxrx.subscriptions.Single;
import buddy.BuddySuite;

using buddy.Should;

class AutoDetachingObserverTests extends BuddySuite
{
    public function new()
    {
        describe('AutoDetachingObserver', {
            it('will dispose of the subscription once the observer completes', {
                var disposed = false;

                final subscription = new Single(() -> disposed = true);
                final observer     = new AutoDetachingObserver(new Observer(null, null, null));

                observer.setSubscription(subscription);

                disposed.should.be(false);
                observer.onCompleted();
                disposed.should.be(true);
            });
            it('will dispose of the subscription once the observer errors', {
                var disposed = false;

                final subscription = new Single(() -> disposed = true);
                final observer     = new AutoDetachingObserver(new Observer(null, null, null));

                observer.setSubscription(subscription);

                disposed.should.be(false);
                observer.onError(new Exception('error'));
                disposed.should.be(true);
            });
            it('will immediately dispose of the subscription on setting if the parent observer has completed', {
                var disposed = false;

                final subscription = new Single(() -> disposed = true);
                final observer     = new AutoDetachingObserver(new Observer(null, null, null));

                observer.onCompleted();

                disposed.should.be(false);
                observer.setSubscription(subscription);
                disposed.should.be(true);
            });
            it('will immediately dispose of the subscription on setting if the parent observer has errored', {
                var disposed = false;

                final subscription = new Single(() -> disposed = true);
                final observer     = new AutoDetachingObserver(new Observer(null, null, null));

                observer.onError(new Exception('error'));

                disposed.should.be(false);
                observer.setSubscription(subscription);
                disposed.should.be(true);
            });
        });
    }
}