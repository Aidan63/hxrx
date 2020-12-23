import buddy.Buddy;
import observables.FlatMapTests;

class Tests implements Buddy<[
    observables.FlatMapTests,
    observables.MapTests,
    observables.ScanTests,
    observables.PublishTests,
    observables.RefCountTests,
    schedulers.ImmediateSchedulerTests,
    schedulers.CurrentSchedulerTests, ]> { }