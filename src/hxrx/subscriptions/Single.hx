package hxrx.subscriptions;

class Single implements ISubscription
{
    var done : Bool;

    final func : Null<()->Void>;

    public function new(_func = null)
    {
        done = false;
        func = _func;
    }

    public function unsubscribe()
    {
        if (!done)
        {
            if (func != null)
            {
                func();
            }

            done = true;
        }
    }
}