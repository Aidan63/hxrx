package hxrx.subscriptions;

class Composite implements ISubscription
{
    final subscriptions : Array<ISubscription>;

    var done : Bool;

    public function new(_subscriptions)
    {
        subscriptions = _subscriptions;
        done          = false;
    }

    public function unsubscribe()
    {
        if (!done)
        {
            for (subscription in subscriptions)
            {
                subscription.unsubscribe();
            }
    
            done = true;   
        }
    }
}