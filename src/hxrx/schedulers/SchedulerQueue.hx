package hxrx.schedulers;

import haxe.ds.ArraySort;

class SchedulerQueue
{
    final array : Array<ScheduledItem>;

    public function new()
    {
        array = [];
    }

    public function enqueue(_item : ScheduledItem)
    {
        array.push(_item);

        ArraySort.sort(array, sorter);
    }

    public function dequeue()
    {
        return array.shift();
    }

    public function isEmpty()
    {
        return array.length == 0;
    }

    function sorter(_item1 : ScheduledItem, _item2 : ScheduledItem)
    {
        if (_item1.dueTime < _item2.dueTime)
        {
            return -1;
        }
        if (_item1.dueTime > _item2.dueTime)
        {
            return 1;
        }

        return 0;
    }
}