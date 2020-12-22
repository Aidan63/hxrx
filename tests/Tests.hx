import buddy.Buddy;
import observables.FlatMapTests;

class Tests implements Buddy<[
    observables.FlatMapTests,
    observables.MapTests,
    observables.ScanTests,
    observables.PublishTests,
    schedulers.ImmediateSchedulerTests,
    schedulers.CurrentSchedulerTests, ]> { }