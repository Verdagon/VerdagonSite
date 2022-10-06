Vale is a programming language that combines new memory management
techniques in order to be easy to learn, memory safe, deterministic, and
fast.

One of those new memory management techniques is \*type stability,\*
where an object\'s memory is only ever reused for the same type.

Type stability lets us have memory safety without the usual costs:

\* without run-time aliasing costs (like with reference counting)

\* without added constraints or complexity (like with borrow checking)

\* without run-time pauses (like with tracing garbage collection)

\* without extra copies or bounds checking \[#bounds\] (like in Rust
programs)

\* without dereferencing costs (like with generational references)

With type stability, it is \*memory-safe to mutably alias any object.\*
\[1\]

We\'ll explain these benefits below, plus its drawbacks and how Vale
addresses them.

Keep reading to learn how it works!

\# What is Type Stability?

\## Simple Type Stability

Imagine we had a basic C program that used \`malloc\`, but had a special
\`free\` function that, instead of returning the memory to the OS, just
adds it to a free-list specifically for that object\'s type.

Suddenly, our program has memory safety for free!

If we accidentally use-after-free, it\'s still memory-safe because
we\'re accessing something of the same type as the original object.

Type stability is when we \*only reuse an object\'s memory for the same
type.\*

There are other type-stable approaches besides this simple \`malloc\` +
free-list one, which we\'ll explain further below.

\## This is familiar!

We do something similar to this with arrays in C, C++, and Rust, all the
time!

Let\'s say we have an array of \`Spaceship\`, and a local \`int myShip =
3;\` which refers to a specific ship.

Later, we reuse that slot in the array for a different \`Spaceship\`. We
of course shouldn\'t use \`myShip\` again, because it\'s a \"dangling
index\" so to speak.

But if we \_do\_ accidentally use \`myShip\` to index into the array,
it\'s still memory safe, because we\'re still accessing a \`Spaceship\`.

Our simple \`malloc\` + free-list strategy above is the same; if we
use-after-free, we\'re still accessing something of the right type, so
it\'s memory safe!

\# Benefits and Drawbacks

\## The Benefits

This simple approach has a lot of benefits.

\*There\'s no aliasing costs.\* In some approaches like reference
counting, we need to store a counter for every object, to increment it
whenever we make a new reference, and decrement it whenever we release a
reference.

That counter makes sure that we don\'t give an object back to \`free\`
until we\'re sure that there are no more references to it, to prevent
use-after-free.

However, with type-stability, use-after-free is memory-safe, so it
doesn\'t need a counter!

\*There\'s no added constraints or complexity.\* With pure borrow
checking, \[# Pure borrow checking is when borrow-checking is not
assisted by \`Rc\` or \`unsafe\`. In other words, idiomatic Rust.\]
we\'re unable to do many useful patterns such as the observer pattern,
and we have to internalize a large toolkit of workarounds for the borrow
checker.

Borrow checking protects us from use-after-free. \[# Borrow checking
also protects us from \*inline data type instability\*, explained more
below.\]

However, with type-stability, use-after-free is memory-safe, so it
doesn\'t need a borrow checker!

\*There\'s no run-time pauses.\* With tracing garbage collection, we
occasionally need to freeze the current thread, so we can see what
objects the thread can indirectly reach, so it can reuse all the
unreachable memory.

Tracing garbage collection will make sure that we don\'t reuse an
object\'s memory until nothing can indirectly access it, and therefore
don\'t use-after-free.

However, with type-stability, use-after-free is memory-safe, so it
doesn\'t need a tracing garbage collector!

\*There\'s no extra copies or bounds checking.\* In Rust, the borrow
checker\'s lack of mutable aliasing often means we store our objects in
a centrally reachable place, usually a \`Vec\` or a \`HashMap\`.

This is a very powerful design pattern, but it does mean we incur a
bounds-check whenever we need to dereference a non-owning non-temporary
reference. \[# In idiomatic Rust, if we need to refer to an object for
longer than a certain scope, or while someone else might mutate it, we
generally must refer to it via an index or an ID.\]

Another workaround is to copy data, instead of putting it in a centrally
reachable place.

This copying and bounds-checking is fortunately usually fairly cheap,
though sometimes it can add up.

However, with type-stability, it\'s safe to mutably alias objects, so it
doesn\'t need to incur bounds checking or copying costs!

\*There\'s no dereferencing costs.\* With \[generational
references\](vision/safety-1-generational-references) and
\[hybrid-generational
memory\](vision/speed-6-hybrid-generational-memory), we sometimes have
to \"generation check\", to assert that our reference\'s generation
matches the allocation\'s current generation which is changed whenever
the object is \`free\`d.

That assertion will make sure we don\'t access an object after it\'s
\`free\`d, because use-after-free is normally memory-unsafe.

However, with type-stability, use-after-free is memory-safe, so we
don\'t need a counter!

\## The Drawbacks, So Far

So far, we\'ve explained a very simple type-stable approach,
\`malloc\` + free-list.

While its benefits are impressive, there are some drawbacks we should
address.

We explain the drawbacks here, and solutions for them below.

\*They can use a lot of memory.\*

explain why

Best use it explicitly (with allocators. like a rust program!) or
temporarily (with region borrow checker)

\*Objects can\'t live inside other objects.\*

explain why

hint that final refs, unique refs help with this

\*Objects can\'t be on the stack.\*

explain why

hint that unique refs, shape stability can help

\*It uses malloc.\*

But it doesnt have to. can do this with any allocator, if you add a
free-list-per-type.

\# Improvements

\## Region Borrow Checker

It lets us blast away all memory used for a temporary pure call.

It also limits the number of

explain more

See \[Safety: Region Borrow
Checker\](vision/safety-3-region-borrow-checker) and \[Speed: Region
Borrow Checker\](vision/speed-3-region-borrow-checker) for more on the
region borrow checker!

\## Allocators

We can opt-in to use it for specific allocations, thus limiting how many
free-lists there are. Not that free-lists are that expensive.

See \[Allocators\](vision/speed-3-allocators) for more on allocators.

Also, ew, we use malloc!

But we can do this with any allocator we want ;)

See \[Allocators\](vision/speed-3-allocators) for more on allocators.

\## Final References

This solves that objects cant live inside other objects. The type there
is always the same, so solved.

\## Unique references

This solves it, we can change something as long as we dont mutate it.

The region borrow checker lets us temporarily see a unique reference as
non-unique.

\## Shape Stability

An object is \*shape-stable\* as long as its memory isn\'t reused for
another type.

It is memory-safe to mutably alias a shape-stable object. An object is
shape-stable as long as its memory isn\'t reused for an object of an
incompatible shape.

\# Final Notes

An entire program could use this approach, if it had only a few types.

For the rest of our programs, this is a great approach for our temporary
calls. Get that memory safety with zero run-time cost!

\# Afterword

(maybe these belong in speed?)

\- Pure functions are particularly cool. When we have a reference into
an immutable region, that entire region is type-stable, which means we
can skip a lot of overhead.

\- We can temporarily use per-type free-lists for generational memory or
HGM, thus unleashing Catalyst and the optimizer.

For a given scope, we can scope-tether an object, so the allocator
doesn\'t reuse its memory for a different type.

In type-stable regions, we know we\'re only using type-stable
allocators.
