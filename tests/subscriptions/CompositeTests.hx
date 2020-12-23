package subscriptions;

import hxrx.subscriptions.Composite;
import hxrx.subscriptions.Single;
import buddy.BuddySuite;

using buddy.Should;

class CompositeTests extends BuddySuite
{
    public function new()
    {
        describe('Composite', {
            it('will only call unsubscribe on child subscriptions the first time its unsubscribed', {
                var output = [];

                final expected     = [ 2, 4 ];
                final subscription = new Composite([
                    new Single(() -> output.push(2)),
                    new Single(() -> output.push(4))
                ]);

                subscription.unsubscribe();
                output.should.containExactly(expected);
                subscription.unsubscribe();
                output.should.containExactly(expected);
            });
        });
    }
}