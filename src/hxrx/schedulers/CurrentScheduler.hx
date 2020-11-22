package hxrx.schedulers;

import hxrx.subscriptions.Single;
import sys.thread.Tls;
import hxrx.subscriptions.Empty;
import haxe.Timer;

class CurrentScheduler implements IScheduler
{
    public var running : Tls<Bool>;

    public final queue : Tls<List<ScheduledItem>>;

    public function new()
    {
        running = new Tls();
        queue   = new Tls();
    }

    public function time() return Timer.stamp();

    public function schedule(_task : (_scheduler : IScheduler) -> ISubscription, _time : Float)
    {
        if (!running.value)
        {
            running.value = true;

            if (_time > 0)
            {
                Sys.sleep(_time);
            }

            var subscription : ISubscription = null;
            try
            {
                subscription = _task(this);
            }
            catch (e)
            {
                queue.value = null;

                running.value = false;

                throw e;
            }

            final q = queue.value;
            if (q != null)
            {
                try
                {
                    run(q);
                }
                catch (_) {}

                queue.value = null;

                running.value = false;
            }
            else
            {
                running.value = false;
            }

            return subscription;
        }

        var q = queue.value;

        if (q == null)
        {
            queue.value = new List();
        }

        final dt = time() + _time;
        final si = new ScheduledItem(this, _task, dt);

        queue.value.push(si);

        return si;
    }

    function run(_queue : List<ScheduledItem>)
    {
        while (_queue.length > 0)
        {
            final item = _queue.pop();
    
            if (!item.cancelled)
            {
                final wait = item.dueTime - time();
    
                if (wait > 0)
                {
                    Sys.sleep(wait);
                }
    
                if (!item.cancelled)
                {
                    item.invoke();
                }
            }
        }
    }
}