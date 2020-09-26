package hxrx.subscriptions;

class Single implements ISubscription
{
    var done : Bool;

    final func : ()->Void;

    public function new(_func)
    {
        done = false;
        func = _func;
    }

    public function unsubscribe()
    {
        if (!done)
        {
            func();

            done = true;
        }
    }
}