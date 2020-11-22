package schedulers;

import haxe.Timer;
import hxrx.subscriptions.Empty;
import hxrx.schedulers.ImmediateScheduler;
import buddy.BuddySuite;

using buddy.Should;

class ImmediateSchedulerTests extends BuddySuite
{
    public function new()
    {
        describe('ImmediateScheduler', {
            it('can return the current time in seconds', {
                final now  = Timer.stamp();
                final time = new ImmediateScheduler().time();

                (time - now).should.beLessThan(0.1);
            });

            describe('scheduleNow', {
                it('will return after the scheduled function has ran', {
                    var result   = 0;
                    var expected = 5;
    
                    new ImmediateScheduler().scheduleNow(scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });
    
                    result.should.be(expected);
                });
                it('will run inner scheduled tasks immediately', {
                    var result   = [];
                    var expected = [ 5, 7 ];
    
                    new ImmediateScheduler().scheduleNow(scheduler -> {
                        scheduler.scheduleNow(scheduler -> {
                            result.push(5);
    
                            return new Empty();
                        });
    
                        result.push(7);
    
                        return new Empty();
                    });
    
                    result.should.containExactly(expected);
                });
            });
            describe('scheduleIn', {
                it('will delay for the specified time in seconds and return after the scheduled function has ran', {
                    var result   = 0;
                    var expected = 5;

                    final t1 = Timer.stamp();

                    new ImmediateScheduler().scheduleIn(1, scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();
    
                    result.should.be(expected);
                    (t2 - t1).should.beGreaterThan(1);
                });
                it('will run inner scheduled tasks immediately but first delay by the specified time', {
                    var result   = [];
                    var expected = [ 5, 7 ];

                    final t1 = Timer.stamp();
    
                    new ImmediateScheduler().scheduleIn(1, scheduler -> {
                        scheduler.scheduleIn(1, scheduler -> {
                            result.push(5);
    
                            return new Empty();
                        });
    
                        result.push(7);
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();
    
                    result.should.containExactly(expected);
                    (t2 - t1).should.beGreaterThan(2);
                });
            });
            describe('scheduleAt', {
                it('will delay until the target date has arrived and return after the scheduled function has ran', {
                    var result   = 0;
                    var expected = 5;

                    final target = DateTools.delta(Date.now(), DateTools.seconds(1));
                    final t1     = Timer.stamp();

                    new ImmediateScheduler().scheduleAt(target, scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();

                    result.should.be(expected);
                    (t2 - t1).should.beGreaterThan(1);
                });
                it('will run inner scheduled tasks immediately but first wait until the target date has arrived', {
                    var result   = [];
                    var expected = [ 5, 7 ];

                    final target = DateTools.delta(Date.now(), DateTools.seconds(1));
                    final t1     = Timer.stamp();
    
                    new ImmediateScheduler().scheduleAt(target, scheduler -> {
                        final target = DateTools.delta(Date.now(), DateTools.seconds(1));

                        scheduler.scheduleAt(target, scheduler -> {
                            result.push(5);
    
                            return new Empty();
                        });
    
                        result.push(7);
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();
    
                    result.should.containExactly(expected);
                    (t2 - t1).should.beGreaterThan(2);
                });
            });
        });
    }
}