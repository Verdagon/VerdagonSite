An honest appraisal of Rust

Assuming NO unsafe. (though, we really should write it with the more
enlightened balanced use of unsafe, the building blocks approach jon
talked about)

Some things about this kind of Rust:

It doesn\'t promise no bugs. Rust never made that promise.

You can\'t program the way you used to. Things that are completely
reasonable in other programming languages will straight-up \*not work\*
in Pure Rust. See ABCDE problem.

You have to do wild acrobatics to get used to this kind of programming.
Often, you\'re just moving bugs from one category to a slightly less
terrifying but harder to use category (see indices vs pointers).

Benefits of this rust:

Complete, zero-overhead memory safety on linear types (in other words,
strict trees).

Complete (with some overhead) memory safety on directed acyclic graphs
(with use of Rc/RefCell, but you enter risky technically-deterministic
Drop territory)

No undefined behavior (with some overhead) on everything else (talking
RefCell, Rc here).

Things Rust does better than Java-like languages:

\- Almost all overhead is opt-in.

\- Destructors (again, only on linear types; strict trees). Finalizers
\*do not count\*. Destructors are amazing because they\'re a way to
prevent forgetting to call something.

purely safe rust, no Rc, RefCell, panics, etc.

is it expected/encouraged to write rust without use of expect/panic?

rust catches 50% of its lifetime errors at compile time and 50% at
runtime. it gets 100 on performance, 10 on ease of use.

radon catches 10% of its lifetime errors at compile time and 90% at
runtime. it gets 90 on performance, 100 on ease of use.

When we move c++ to rust:

-   shared_ptr becomes Rc

-   weak_ptr becomes Weak

-   unique_ptr will become a regular type

-   raw ptr at a unique_ptr becomes:

    -   if linear (not so common), a regular reference

    -   if a back reference (very common), **no good answer.** maybe an
        > index into a pool?

    -   a downward reference (not so common), **no good answer.** mayne
        > nothing? maybe an index?

    -   cyclical (somewhat common), **no good answer.** an index into a
        > pool?

    -   if non-lifetime-constrained: **no good answer.** an index or
        > unsafe pointer?

When we move c++ to V:

-   shared_ptr becomes:

    -   if only used so we can weak_ptr to it: an owning reference

    -   if used for shared ownership: a Handle into a pool

-   weak_ptr becomes:

    -   if only used so we can weak at a single owner shared_ptr: a weak
        > reference

    -   if used so we can weak at a multiple owned thing: WeakHandle
        > into a pool

-   unique_ptr will become an owning reference

-   raw ptr at a unique_ptr becomes:

    -   if linear (not so common), a strong borrow

    -   if a back reference (very common), a strong borrow

    -   a downward reference (not so common), probably nothing? or a
        > strong borrow.

    -   cyclical (somewhat common), an index into a pool

    -   if non-lifetime-constrained: a weak reference

V has good answers for all C++ cases. Rust doesn\'t.
