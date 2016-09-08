"use strict"

describe "Promise-specific extensions:", =>
    promise = null
    error = new Error("boo")
    custom = "No. I am your father."

    assertingDoneFactory = (done) =>
        (result) =>
            try
                expect(result).to.equal(error)
            catch assertionError
                return done(assertionError)

            done()

    describe "when the promise is fulfilled", =>
        beforeEach =>
            promise = fulfilledPromise()
            return undefined

        describe ".fulfilled", =>
            shouldPass => promise.should.be.fulfilled
        describe ".not.fulfilled", =>
            shouldFail
                op: => promise.should.not.be.fulfilled
                message: "not to be fulfilled but it was fulfilled with undefined"

        describe ".rejected", =>
            shouldFail
              op: => promise.should.be.rejected
              message: "to be rejected but it was fulfilled with undefined"
        describe ".rejectedWith(TypeError)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(TypeError)
                message: "to be rejected with 'TypeError' but it was fulfilled with undefined"
        describe ".rejectedWith('message substring')", =>
            shouldFail
                op: => promise.should.be.rejectedWith("message substring")
                message: "to be rejected with an error including 'message substring' but it was fulfilled with " +
                         "undefined"
        describe ".rejectedWith(/regexp/)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(/regexp/)
                message: "to be rejected with an error matching /regexp/ but it was fulfilled with undefined"
        describe ".rejectedWith(TypeError, 'message substring')", =>
            shouldFail
                op: => promise.should.be.rejectedWith(TypeError, "message substring")
                message: "to be rejected with 'TypeError' but it was fulfilled with undefined"
        describe ".rejectedWith(TypeError, /regexp/)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(TypeError, /regexp/)
                message: "to be rejected with 'TypeError' but it was fulfilled with undefined"
        describe ".rejectedWith(errorInstance)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(error)
                message: "to be rejected with [Error: boo] but it was fulfilled with undefined"

        describe ".not.rejected", =>
            shouldPass => promise.should.not.be.rejected
        describe ".not.rejectedWith(TypeError)", =>
            shouldPass => promise.should.not.be.rejectedWith(TypeError)
        describe ".not.rejectedWith('message substring')", =>
            shouldPass => promise.should.not.be.rejectedWith("message substring")
        describe ".not.rejectedWith(/regexp/)", =>
            shouldPass => promise.should.not.be.rejectedWith(/regexp/)
        describe ".not.rejectedWith(TypeError, 'message substring')", =>
            shouldPass => promise.should.not.be.rejectedWith(TypeError, "message substring")
        describe ".not.rejectedWith(TypeError, /regexp/)", =>
            shouldPass => promise.should.not.be.rejectedWith(TypeError, /regexp/)
        describe ".not.rejectedWith(errorInstance)", =>
            shouldPass => promise.should.not.be.rejectedWith(error)

        describe ".should.notify(done)", =>
            it "should pass the test", (done) =>
                promise.should.notify(done)

    describe "when the promise is rejected", =>
        beforeEach =>
            promise = rejectedPromise(error)
            return undefined

        describe ".fulfilled", =>
            shouldFail
                op: => promise.should.be.fulfilled
                message: "to be fulfilled but it was rejected with [Error: boo]"
        describe ".not.fulfilled", =>
            shouldPass => promise.should.not.be.fulfilled

        describe ".rejected", =>
            shouldPass => promise.should.be.rejected

        describe ".not.rejected", =>
            shouldFail
                op: => promise.should.not.be.rejected
                message: "not to be rejected but it was rejected with [Error: boo]"

        describe ".rejectedWith(theError)", =>
            shouldPass => promise.should.be.rejectedWith(error)

        describe ".not.rejectedWith(theError)", =>
            shouldFail
                op: => promise.should.not.be.rejectedWith(error)
                message: "not to be rejected with [Error: boo]"

        describe ".rejectedWith(differentError)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(new Error)
                message: "to be rejected with [Error] but it was rejected with [Error: boo]"

        describe ".not.rejectedWith(differentError)", =>
            shouldPass => promise.should.not.be.rejectedWith(new Error)

        # Chai 3.5.0 never interprets the 2nd paramter to
        # expect(fn).to.throw(a, b) as a custom error message. This is
        # what we are testing here.
        describe ".rejectedWith(differentError, custom)", =>
            shouldFail
                op: => promise.should.be.rejectedWith(new Error, custom)
                message: "to be rejected with [Error] but it was rejected with [Error: boo]"
                notMessage: custom

        describe ".not.rejectedWith(differentError, custom)", =>
            shouldPass => promise.should.not.be.rejectedWith(new Error, custom)

        describe "with an Error having message 'foo bar'", =>
            beforeEach =>
                promise = rejectedPromise(new Error("foo bar"))
                return undefined

            describe ".rejectedWith('foo')", =>
                shouldPass => promise.should.be.rejectedWith("foo")

            describe ".not.rejectedWith('foo')", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith("foo")
                    message: "not to be rejected with an error including 'foo'"

            describe ".rejectedWith(/bar/)", =>
                shouldPass => promise.should.be.rejectedWith(/bar/)

            describe ".not.rejectedWith(/bar/)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(/bar/)
                    message: "not to be rejected with an error matching /bar/"

            describe ".rejectedWith('quux')", =>
                shouldFail
                    op: => promise.should.be.rejectedWith("quux")
                    message: "to be rejected with an error including 'quux' but got 'Error: foo bar'"

            describe ".not.rejectedWith('quux')", =>
                shouldPass => promise.should.be.not.rejectedWith("quux")

            describe ".rejectedWith(/quux/)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(/quux/)
                    message: "to be rejected with an error matching /quux/ but got 'Error: foo bar'"

            describe ".not.rejectedWith(/quux/)", =>
                shouldPass => promise.should.not.be.rejectedWith(/quux/)

            # Chai 3.5.0 never interprets the 2nd paramter to
            # expect(fn).to.throw(a, b) as a custom error
            # message. This is what we are testing here.
            describe ".rejectedWith('foo', custom)", =>
                shouldPass => promise.should.be.rejectedWith("foo", custom)

            describe ".not.rejectedWith('foo', custom)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith("foo", custom)
                    message: "not to be rejected with an error including 'foo'"
                    notMessage: custom

            describe ".rejectedWith(/bar/, custom)", =>
                shouldPass => promise.should.be.rejectedWith(/bar/, custom)

            describe ".not.rejectedWith(/bar/, custom)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(/bar/)
                    message: "not to be rejected with an error matching /bar/"
                    notMessage: custom

        describe "with a RangeError", =>
            beforeEach =>
                promise = rejectedPromise(new RangeError)
                return undefined

            describe ".rejectedWith(RangeError)", =>
                shouldPass => promise.should.be.rejectedWith(RangeError)

            describe ".not.rejectedWith(RangeError)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError)
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError]"

            describe ".rejectedWith(TypeError)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(TypeError)
                    message: "to be rejected with 'TypeError' but it was rejected with [RangeError]"

            # Case for issue #64.
            describe ".rejectedWith(Array)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(Array)
                    message: "to be rejected with 'Array' but it was rejected with [RangeError]"

            describe ".not.rejectedWith(TypeError)", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError)

        describe "with a RangeError having a message 'foo bar'", =>
            beforeEach =>
                promise = rejectedPromise(new RangeError("foo bar"))
                return undefined

            describe ".rejectedWith(RangeError, 'foo')", =>
                shouldPass => promise.should.be.rejectedWith(RangeError, "foo")

            describe ".not.rejectedWith(RangeError, 'foo')", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, "foo")
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"

            describe ".rejectedWith(RangeError, /bar/)", =>
                shouldPass => promise.should.be.rejectedWith(RangeError, /bar/)

            describe ".not.rejectedWith(RangeError, /bar/)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, /bar/)
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"

            describe ".rejectedWith(RangeError, 'quux')", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(RangeError, "quux")
                    message: "to be rejected with an error including 'quux' but got 'RangeError: foo bar'"
            describe ".rejectedWith(RangeError, /quux/)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(RangeError, /quux/)
                    message: "to be rejected with an error matching /quux/ but got 'RangeError: foo bar'"

            describe ".rejectedWith(TypeError, 'foo')", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(TypeError, 'foo')
                    message: "to be rejected with 'TypeError' but it was rejected with [RangeError: foo bar]"
            describe ".rejectedWith(TypeError, /bar/)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(TypeError, /bar/)
                    message: "to be rejected with 'TypeError' but it was rejected with [RangeError: foo bar]"

            describe ".rejectedWith(TypeError, 'quux')", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(TypeError, 'quux')
                    message: "to be rejected with 'TypeError' but it was rejected with [RangeError: foo bar]"
            describe ".rejectedWith(TypeError, /quux/)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(TypeError, /quux/)
                    message: "to be rejected with 'TypeError' but it was rejected with [RangeError: foo bar]"

            describe ".not.rejectedWith(RangeError, 'foo')", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, 'foo')
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"
            describe ".not.rejectedWith(RangeError, /bar/)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, /bar/)
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"

            describe ".not.rejectedWith(RangeError, 'quux')", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, 'quux')
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"
            describe ".not.rejectedWith(RangeError, /quux/)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, /quux/)
                    message: "not to be rejected with 'RangeError' but it was rejected with [RangeError: foo bar]"

            describe ".not.rejectedWith(TypeError, 'foo')", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(TypeError, "foo")
                    message: "not to be rejected with an error including 'foo'"
            describe ".not.rejectedWith(TypeError, /bar/)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(TypeError, /bar/)
                    message: "not to be rejected with an error matching /bar/"

            describe ".not.rejectedWith(TypeError, 'quux')", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError, "quux")
            describe ".not.rejectedWith(TypeError, /quux/)", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError, /quux/)
            describe ".rejectedWith(RangeError, 'foo', custom)", =>
                shouldPass => promise.should.be.rejectedWith(RangeError, "foo", custom)

            describe ".not.rejectedWith(RangeError, 'foo', custom)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, "foo", custom)
                    message: custom

            describe ".rejectedWith(RangeError, /bar/, custom)", =>
                shouldPass => promise.should.be.rejectedWith(RangeError, /bar/, custom)

            describe ".not.rejectedWith(RangeError, /bar/, custom)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, /bar/, custom)
                    message: custom

            describe ".rejectedWith(RangeError, 'quux', custom)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(RangeError, "quux", custom)
                    message: custom

            describe ".not.rejectedWith(TypeError, 'quux', custom)", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError, "quux", custom)

            describe ".rejectedWith(RangeError, /quux/, custom)", =>
                shouldFail
                    op: => promise.should.be.rejectedWith(RangeError, /quux/, custom)
                    message: custom

            describe ".not.rejectedWith(TypeError, /quux/, custom)", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError, /quux/, custom)

            describe ".rejectedWith(RangeError, undefined, custom)", =>
                shouldPass => promise.should.be.rejectedWith(RangeError, undefined, custom)

            describe ".not.rejectedWith(RangeError, undefined, custom)", =>
                shouldFail
                    op: => promise.should.not.be.rejectedWith(RangeError, undefined, custom)
                    message: custom

            describe ".rejectedWith(TypeError, undefined, custom)", =>
                shouldFail
                op: => promise.should.be.rejectedWith(TypeError, undefined, custom)
                message: custom

            describe ".not.rejectedWith(TypeError, undefined, custom)", =>
                shouldPass => promise.should.not.be.rejectedWith(TypeError, undefined, custom)

        describe ".should.notify(done)", =>
            it "should fail the test with the original error", (done) =>
                promise.should.notify(assertingDoneFactory(done))

    describe ".should.notify with chaining (GH-3)", =>
        describe "the original promise is fulfilled", =>
            beforeEach =>
                promise = fulfilledPromise()
                return undefined

            describe "and the follow-up promise is fulfilled", =>
                beforeEach =>
                    promise = promise.then(=>)
                    return undefined

                it "should pass the test", (done) =>
                    promise.should.notify(done)

            describe "but the follow-up promise is rejected", =>
                beforeEach =>
                    promise = promise.then(=> throw error)
                    return undefined

                it "should fail the test with the error from the follow-up promise", (done) =>
                    promise.should.notify(assertingDoneFactory(done))

        describe "the original promise is rejected", =>
            beforeEach =>
                promise = rejectedPromise(error)
                return undefined

            describe "but the follow-up promise is fulfilled", =>
                beforeEach =>
                    promise = promise.then(=>)
                    return undefined

                it "should fail the test with the error from the original promise", (done) =>
                    promise.should.notify(assertingDoneFactory(done))

            describe "and the follow-up promise is rejected", =>
                beforeEach =>
                    promise = promise.then(=> throw new Error("follow up"))
                    return undefined

                it "should fail the test with the error from the original promise", (done) =>
                    promise.should.notify(assertingDoneFactory(done))

    describe "Using with non-thenables", =>
        describe "A number", =>
            number = 5

            it "should fail for .fulfilled", =>
                expect(=> number.should.be.fulfilled).to.throw(TypeError, "not a thenable")
            it "should fail for .rejected", =>
                expect(=> number.should.be.rejected).to.throw(TypeError, "not a thenable")
            it "should fail for .become", =>
                expect(=> number.should.become(5)).to.throw(TypeError, "not a thenable")
            it "should fail for .eventually", =>
                expect(=> number.should.eventually.equal(5)).to.throw(TypeError, "not a thenable")
            it "should fail for .notify", =>
                expect(=> number.should.notify(=>)).to.throw(TypeError, "not a thenable")

    describe "Using together with other Chai as Promised asserters", =>
        describe ".fulfilled.and.eventually.equal(42)", =>
            shouldPass => fulfilledPromise(42).should.be.fulfilled.and.eventually.equal(42)
        describe ".fulfilled.and.rejected", =>
            shouldFail
                op: => fulfilledPromise(42).should.be.fulfilled.and.rejected
                message: "to be rejected but it was fulfilled with 42"

        describe ".rejected.and.eventually.equal(42)", =>
            shouldPass => rejectedPromise(42).should.be.rejected.and.eventually.equal(42)
        describe ".rejected.and.become(42)", =>
            shouldPass => rejectedPromise(42).should.be.rejected.and.become(42)

    describe "With promises that only become rejected later (GH-24)", =>
        it "should wait for them", (done) =>
            deferred = defer()
            deferred.promise.should.be.rejectedWith("error message").and.notify(done)

            setTimeout(
                => deferred.reject(new Error("error message"))
                100
            )

    describe "`rejectedWith` with non-`Error` rejection reasons (GH-33)", =>
        shouldPass => rejectedPromise(42).should.be.rejectedWith(42)
