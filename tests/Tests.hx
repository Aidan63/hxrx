import buddy.Buddy;
import observables.FlatMapTests;

class Tests implements Buddy<[
    observables.FlatMapTests,
    observables.MapTests,
    observables.ScanTests,
    observables.PublishTests,
    observables.RefCountTests,
    observables.CreateTests,
    observer.AutoDetachingObserverTests,
    schedulers.ImmediateSchedulerTests,
    schedulers.CurrentSchedulerTests,
    subscriptions.SingleTests,
    subscriptions.CompositeTests ]> { }