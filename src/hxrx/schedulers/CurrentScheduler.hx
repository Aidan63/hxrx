package hxrx.schedulers;

import sys.thread.Tls;
import haxe.Timer;

class CurrentScheduler implements IScheduler
{
    var running : Tls<Bool>;

    final queue : Tls<SchedulerQueue>;

    public function new()
    {
        running = new Tls();
        queue   = new Tls();
    }

    public function time() return Timer.stamp();

    public function scheduleNow(_task : (_scheduler : IScheduler) -> ISubscription)
    {
        return scheduleIn(0, _task);
    }

    public function scheduleAt(_dueTime : Date, _task : (_scheduler : IScheduler) -> ISubscription)
    {
        final diff = _dueTime.getTime() - Date.now().getTime();

        return scheduleIn(diff / 1000, _task);
    }

    public function scheduleIn(_dueTime : Float, _task : (_scheduler : IScheduler) -> ISubscription)
    {
        if (!running.value)
        {
            running.value = true;

            if (_dueTime > 0)
            {
                Sys.sleep(_dueTime);
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
            queue.value = new SchedulerQueue();
        }

        final dt = time() + _dueTime;
        final si = new ScheduledItem(this, _task, dt);

        queue.value.enqueue(si);

        return si;
    }

    function run(_queue : SchedulerQueue)
    {
        while (!_queue.isEmpty())
        {
            final item = _queue.dequeue();
    
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