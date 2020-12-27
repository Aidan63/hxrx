package schedulers;

import haxe.Timer;
import hxrx.subscriptions.Empty;
import hxrx.schedulers.CurrentScheduler;
import buddy.BuddySuite;

using buddy.Should;

class CurrentSchedulerTests extends BuddySuite
{
    public function new()
    {
        describe('CurrentScheduler', {
            it('can return the current time in seconds', {
                final now  = Timer.stamp();
                final time = new CurrentScheduler().time();

                (time - now).should.beLessThan(0.1);
            });

            describe('scheduleNow', {
                it('will return after the scheduled function has ran', {
                    var result   = 0;
                    var expected = 5;
    
                    new CurrentScheduler().scheduleNow(scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });
    
                    result.should.be(expected);
                });
                it('will run inner scheduled tasks after the outer', {
                    var result   = [];
                    var expected = [ 7, 5 ];
    
                    new CurrentScheduler().scheduleNow(scheduler -> {
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

                    new CurrentScheduler().scheduleIn(1, scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();
    
                    result.should.be(expected);
                    ((t2 - t1) >= 1).should.be(true);
                });
                it('will delay by the specified time before running inner functions', {
                    var result   = [];
                    var expected = [ 7, 5 ];

                    final t1 = Timer.stamp();
    
                    new CurrentScheduler().scheduleIn(1, scheduler -> {
                        scheduler.scheduleIn(1, scheduler -> {
                            result.push(5);
    
                            return new Empty();
                        });
    
                        result.push(7);
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();
    
                    result.should.containExactly(expected);
                    ((t2 - t1) >= 2).should.be(true);
                });
                it('will sort scheduled tasks and execute based on time', {
                    var result     = 0;
                    final expected = 1;

                    new CurrentScheduler().scheduleNow(s -> {
                        final sub = s.scheduleIn(2, _ -> {
                            result = 2;

                            return new Empty();
                        });

                        s.scheduleIn(1, _ -> {
                            sub.unsubscribe();
            
                            return new Empty();
                        });
            
                        result = 1;
            
                        return new Empty();
                    });

                    result.should.be(expected);
                });
            });
            describe('scheduleAt', {
                it('will delay until the target date has arrived and return after the scheduled function has ran', {
                    var result   = 0;
                    var expected = 5;

                    final target = DateTools.delta(Date.now(), DateTools.seconds(1));
                    final t1     = Timer.stamp();

                    new CurrentScheduler().scheduleAt(target, scheduler -> {
                        result = expected;
    
                        return new Empty();
                    });

                    final t2 = Timer.stamp();

                    result.should.be(expected);
                    ((t2 - t1) >= 1).should.be(true);
                });
                it('will will wait until the target date until running inner scheduled tasks', {
                    var result   = [];
                    var expected = [ 7, 5 ];

                    final target = DateTools.delta(Date.now(), DateTools.seconds(1));
                    final t1     = Timer.stamp();
    
                    new CurrentScheduler().scheduleAt(target, scheduler -> {
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
                    ((t2 - t1) >= 2).should.be(true);
                });
            });
        });
    }
}