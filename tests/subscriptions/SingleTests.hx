package subscriptions;

import hxrx.subscriptions.Single;
import buddy.BuddySuite;

using buddy.Should;

class SingleTests extends BuddySuite
{
    public function new()
    {
        describe('Single', {
            it('will only call the function the first time its unsubscribed', {
                var counter = 0;

                final expected = 1;
                final subscription = new Single(() -> counter++);

                subscription.unsubscribe();
                counter.should.be(expected);
                subscription.unsubscribe();
                counter.should.be(expected);
            });
        });
    }
}