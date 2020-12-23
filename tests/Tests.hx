import buddy.Buddy;
import observables.FlatMapTests;

class Tests implements Buddy<[
    observables.FlatMapTests,
    observables.MapTests,
    observables.ScanTests,
    observables.PublishTests,
    observables.RefCountTests,
    observer.AutoDetachingObserverTests,
    schedulers.ImmediateSchedulerTests,
    schedulers.CurrentSchedulerTests, ]> { }