package subjects;

import haxe.Exception;
import hxrx.observer.Observer;
import hxrx.subjects.PublishSubject;
import buddy.BuddySuite;

using buddy.Should;

class PublishSubjectTests extends BuddySuite
{
    public function new()
    {
        describe('PublishSubject', {
            describe('Subscribing After Completing', {
                var counter   = 0;
                var completed = false;

                final subject = new PublishSubject();

                subject.onCompleted();
                subject.subscribe(new Observer(v -> counter += v, e -> throw e, () -> completed = true));
                subject.onNext(1);

                it('will complete the observer on subscribing', {
                    completed.should.be(true);
                });
                it('will not recieve any more events from the subject', {
                    counter.should.be(0);
                });
            });
            describe('Subscribing After Erroring', {
                var counter = 0;
                var error   = new Exception('');

                final subject = new PublishSubject();

                subject.onError(new Exception('error'));
                subject.subscribe(new Observer(v -> counter += v, e -> error = e, null));
                subject.onNext(1);

                it('will error the observer on subscribing', {
                    error.message.should.be('error');
                });
                it('will not recieve any more events from the subject', {
                    counter.should.be(0);
                });
            });
        });
    }
}