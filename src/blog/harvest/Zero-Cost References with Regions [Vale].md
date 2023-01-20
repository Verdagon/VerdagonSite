Obsolete; draft moved to
[[https://vale.dev/blog/zero-cost-refs-regions]{.underline}](https://vale.dev/blog/zero-cost-refs-regions)

To do:

-   ~~improve parser for snippets:~~

    -   ~~the \'i on the body~~

    -   ~~the if-let~~

    -   ~~the spaces before the dot~~

-   ~~do notes~~

    -   ~~make double guillemet » count as a comment in the parser and
        > have some sort of postprocessing stage turn it into a
        > noteanchor~~

-   ~~better call-to-action~~

-   ~~stronger intro that says this is a new feature we\'re currently
    > building, and we dont yet know how well it will perform~~

-   ~~come up with a cool name for implicit locking and pool regions~~

-   run this by kixiron

-   post twice to hackernews (once sunday 6pm, once monday when it falls
    > off front, different urls and posters)

-   we should be able to do all these optimizations with the function
    > signature, if u count the \'i on the body

-   ~~mention it could beat c++ in practice~~

# Zero-Cost References with Regions

[[Zero-Cost References with Regions]{.underline}](#_d6moou8vz264)

> [[Reference Counting]{.underline}](#reference-counting)
>
> [[Cycles]{.underline}](#cycles)
>
> [[Atomicity]{.underline}](#atomicity)
>
> [[Branch Mispredictions]{.underline}](#branch-mispredictions)
>
> [[Cache Misses]{.underline}](#cache-misses)
>
> [[Read-Only Regions]{.underline}](#read-only-regions)
>
> [[Implicit Locking]{.underline}](#implicit-locking)
>
> [[Explicit Locking]{.underline}](#explicit-locking)
>
> [[Region Memory Strategy]{.underline}](#region-memory-strategy)
>
> [[Fast and Safe]{.underline}](#fast-and-safe)

Vale is rapidly approaching v0.1, and now that the foundations
(generics, interfaces, closures) are complete, we can tell the world
what\'s in store for Vale.

Vale aims to be as fast as C++, as safe as Java, and easy to learn.
Using a novel combination of single ownership, reference counting,
region borrow checking, and an arsenal of other optimizations, Vale can
reduce ref-counting overhead lower than ever before.

Any safe memory management strategy has run-time overhead. Garbage
collected languages (Java, Javascript) must \"stop the world\" for
milliseconds at a time, and reference counting languages (Python, Swift,
ObjC, some C++) pay costs in incrementing and decrementing ref counts.
Even borrow checking languages (Rust, Cyclone) pay RC or Vec costs, when
the borrow checker forces us into them.

Vale is no exception; its Normal Mode and Resilient Mode guarantee
memory safety, but have some minor overhead at run-time. However,
Vale\'s **region borrow checking, compile time ref-counting, constraint
references, memory pools, and bump allocation** work together to
drastically reduce the overhead, giving us speed with perfect memory
safety.

v0.2 will be the regions release, where add support for all of these
features. We\'re still designing it and seeing if it will work! Let us
know if you have any questions or ideas, or if you see any opportunities
or mistakes!

## Reference Counting

Vale uses reference counting to guarantee safety: whenever we make a new
reference to an object, we must increment that object\'s **reference
count**, and when that reference goes away, we must decrement it again.
We can\'t deallocate an object until its reference count is zero.

The first optimization that will help with this is called **compile-time
reference counting.** It was invented by Wouter van Oortmerssen for
Lobster, and it uses Rust-inspired lifetime analysis to eliminate 95% of
increments and decrements at compile time, leaving only 5% to happen at
run-time.

Now let\'s look at the overhead of the remaining 5%. Reference counting
has what is commonly known as the **three vexing fears: cycles,
atomicity, mispredictions, and cache-misses.** Vale solves all of them.

### Cycles

The first weakness of RC is that it can form cycles, causing memory
leaks. Vale doesn\'t have this problem because every object has one
owning reference, and it enforces that no other references are alive
when we let go of the owning reference.

### Atomicity

When two threads increment or decrement the same object\'s reference
count, they can interfere with each other. There are various ways to
avoid this:

-   In Python, the incrementing/decrementing is non-atomic, but that
    > means only one thread can run at a given time.

-   In Swift, we can have multiple threads, but it means every reference
    > count is atomic, which is very slow.

Christian Aichinger tried making Python\'s ref-counting atomic, and it
resulted in a [[23%
slowdown]{.underline}](https://greek0.net/blog/2015/05/23/python_atomic_refcounting_slowdown/).
This is probably the main reason Swift is slower than C.

In Vale, an object can only be modified by one thread at a time, so a
program can have threads and still use non-atomic ref-counting.

### Branch Mispredictions

RC can also suffer from branch misprediction, where the CPU can\'t
predict whether we\'ll deallocate the object or not. Vale allows the CPU
to perfectly predict: letting go of constraint references will never
deallocate the object, and letting go of owning references will always
deallocate it.

### Cache Misses

A CPU can non-atomically increment or decrement an integer very quickly;
instructions are basically free on modern CPUs. The real bottleneck is
in how far the data is: if it\'s been recently accessed, it\'s in the
nearby cache (the data is \"hot\"). Otherwise the CPU will \"cache
miss\" and have to bring it in all the way from RAM (the data is
\"cold\").

So, even if we make our ref-counting non-atomic and optimize most of it
away, any remaining ref-counts on cold data will still incur cache-miss
costs.

Vale can avoid ref-counting on cold data by using **read-only regions.**

## Read-Only Regions

In Vale, we can split our memory into various regions. We can lock a
region, and all references into it are **completely free**; we don\'t
have to increment or decrement its objects\' ref counts.

We can do this with **implicit locking** and **explicit locking.**

### Implicit Locking

Programs often have \"pure\" functions, where a function reads the
outside world through its parameters, does a bit of calculation (perhaps
modifying some of its own locals along the way), and then returns a
result, all without modifying the outside world. In Vale, we can
annotate a function with the **pure** keyword to make the compiler
enforce this. This is a common design pattern, and leads to much more
maintainable and testable code.

If we add **region markers** to our pure function, Vale will
**implicitly lock** all existing memory, thus making references to any
existing memory **completely free;** we don\'t have to increment or
decrement anything because all these references are temporary
anyway**.** Below, we use region markers (highlighted) to tell the
compiler which references point to the outside world.

Let\'s see it in action! Let\'s say we have a turn-based game, which
runs in Unity. Whenever the player unit acts, each of the enemy units
takes a turn to act too.

+-----------------------------------+-----------------------------------+
| Each enemy unit figures out what  | fn gameLoop(world &World) {       |
| it wants to do most.              |                                   |
|                                   | each unit in world.enemyUnits {   |
| To do this, each unit looks at    |                                   |
| all the things it can do (it\'s   | desire =                          |
| abilities, such as Idle, Wander,  | unit.getStrongestDesire(world);   |
| Pursue, Attack), and asks each    |                                   |
| ability, \"what do you want?\".   | unit.enactDesire(desire);         |
|                                   |                                   |
| A Desire describes what the unit  | }                                 |
| could do, and how much it wants   |                                   |
| to do that.                       | }                                 |
|                                   |                                   |
| When we have all the Desires, we  | pure fn                           |
| sort them to figure out what the  | getStrongestDesire**\<\'i, \'r    |
| strongest one is, and enact it.   | ro\>**                            |
|                                   |                                   |
|                                   | (this **\'r** &Unit)              |
|                                   | Desire**\<\'i, \'r\>** {          |
|                                   |                                   |
|                                   | desires =                         |
|                                   | this.abilities\*.getDesire();     |
|                                   |                                   |
|                                   | desires.sort(                     |
|                                   |                                   |
|                                   | { \_.getStrength() \>             |
|                                   | \_.getStrength() });              |
|                                   |                                   |
|                                   | ret desires\[0\];                 |
|                                   |                                   |
|                                   | }                                 |
+===================================+===================================+
+-----------------------------------+-----------------------------------+

+-----------------------------------+-----------------------------------+
| To generate a desire, an ability  | struct PursueDesire**\<\'i, \'r   |
| will look at its unit and the     | ro\>** {                          |
| world around it.                  |                                   |
|                                   | strength Int;                     |
| For example, PursueAbility\'s     |                                   |
| getDesire function will look for  | victim **\'r** &Unit;             |
| the nearest unit, and return a    |                                   |
| very strong (70!) desire to chase | path List\<Location\>;            |
| it.                               |                                   |
|                                   | fn getStrength(&this impl) Int {  |
| This function doesn\'t change     |                                   |
| anything about itself or the unit | ret this.strength;                |
| or the world, it just reads them  |                                   |
| and does calculations.            | }                                 |
|                                   |                                   |
| By adding the \'r to              | }                                 |
| getStrongestDesire\'s this &Unit, |                                   |
| we\'re telling the compiler that  | pure fn getDesire**\<\'i, \'r     |
| this will come from a region we   | ro\>**                            |
| call \'r.                         |                                   |
|                                   | (this **\'r** &PursueAbility      |
| There\'s no specific region whose | impl) Desire**\<\'i, \'r\>** {    |
| name is \'r (rather, \'r is how   |                                   |
| we refer to whatever region       | unit = this.unit;                 |
| contains this), so it\'s a        |                                   |
| generic parameter, hence the      | world = unit.world;               |
| \<\'r ro\>. The ro specifies that |                                   |
| it\'s a **r**ead-**o**nly region, | loc = unit.location;              |
| making all references into \'r    |                                   |
| free.                             | nearbyUnits =                     |
|                                   | world.findNearbyUnits(loc);       |
|                                   |                                   |
|                                   | closest = nearbyUnits\[0\];       |
|                                   |                                   |
|                                   | path = world.findPath(loc,        |
|                                   | closest.location);                |
|                                   |                                   |
|                                   | ret PursueDesire(70, closest,     |
|                                   | path);                            |
|                                   |                                   |
|                                   | }                                 |
+===================================+===================================+
+-----------------------------------+-----------------------------------+

getDesire is a heavy, read-only operation. It doesn\'t change anything,
but it does breadth-first searches, A\* pathfinding, and a bunch of
other algorithms, which make (and then let go of) a lot of references
into the World.

Without the region markers, every time we make (or let go of) a
reference into the unit or anything else in the world, we increment and
decrement a ref-count. Worse, the World would be cold, because Unity\'s
rendering process has probably rendered a few hundred frames since the
last turn, and has long since wiped our World from the cache.

With the region markers, the compiler knows that only the things
inside the \'i region can change, and nothing in the \'r region will
change, making references into \'r completely free. **All of our
references to this cold data, which would have incurred RC costs, are
now free.**

There is a caveat: When we return a reference from the implicitly locked
call, it increments the ref-count in the object it\'s pointing to. In
the example, PursueDesire.victim will increment the Unit it\'s pointing
at, as it\'s returned. One can often use explicit locking to avoid this
kind of overhead.

### Explicit Locking

Implicit locking locked all existing memory, and made a small new region
called \'i which we could modify. There\'s a more precise way to manage
regions: mutexes!

The Vale compiler itself has a great example of when we\'d want explicit
locking. Six transformation stages translate the source code into
intermediate ASTs and eventually into an executable binary. Each stage
takes in the previous AST, read-only, and constructs the next AST.

One of those is the \"Templar\" stage, which reads the \"astrouts\" AST
and builds the \"temputs\" AST. We can put the astrouts in a Mutex, and
the temputs in another Mutex. The Templar gets read-only access to the
astrouts mutex, while it uses it\'s read-write access to the temputs
mutex to build it up.

+-----------------------------------+-----------------------------------+
| Here, the templar function takes  | fn templar(                       |
| in the astroutsMutex.             |                                   |
|                                   | astroutsMutex                     |
| The astroutsMutex starts closed,  | &!Mutex\<Astrouts\>) {            |
| so we call openro to open it for  |                                   |
| read-only access.                 | astroutsLock =                    |
|                                   | astroutsMutex.openro();           |
| We then create a new Mutex        |                                   |
| containing an empty Temputs. We   | astrouts = astroutsLock.contents; |
| immediately open it in read-write |                                   |
| mode.                             | temputsMutex = Mutex({ Temputs()  |
|                                   | });                               |
| We give both the temputs and a    |                                   |
| function from the astrouts to     | temputsLock =                     |
| translateFunction, so it can make | temputsMutex.openrw();            |
| a translated function and add it  |                                   |
| to temputs.                       | temputs = temputsLock.contents;   |
|                                   |                                   |
| At the end of templar, the locks  | translateFunction(                |
| are dropped, automatically        |                                   |
| closing the mutexes, and we       | astrouts.functions\[0\],          |
| return the now-closed             | &temputs);                        |
| temputsMutex.                     |                                   |
|                                   | \...                              |
| With our Mutexes and region       |                                   |
| annotations, the compiler can     | ret temputsMutex;                 |
| give us free, zero-cost access to |                                   |
| everything in the astrouts.       | }                                 |
|                                   |                                   |
|                                   | fn translateFunction**\<\'a ro,   |
|                                   | \'t\>**(                          |
|                                   |                                   |
|                                   | function \'a &AFunction,          |
|                                   |                                   |
|                                   | temputs \'t &!Temputs) TFunction  |
|                                   | {                                 |
|                                   |                                   |
|                                   | // Read function, add things to   |
|                                   | temputs.                          |
|                                   |                                   |
|                                   | \...                              |
|                                   |                                   |
|                                   | }                                 |
+===================================+===================================+
+-----------------------------------+-----------------------------------+

We still increment and decrement the ref-counts of objects inside \'i,
but we just made those objects, so they\'ll likely be hot in the cache.

We can take this even further: we can combine explicit locking and
implicit locking, and even do implicit locks from within implicit locks.
By layering these locking techniques, we can compound our benefits and
speed up our program even more!

## Region Memory Strategy

In our example above, references into \'r were completely free. And
references into \'i were probably hot in the cache, making its reference
counting very fast.

How much more can we do? **Much more.** This is where things get a bit
crazy.

Vale\'s **pool and arena allocation** can eliminate the ref-counting
overhead in \'i too, and **lets eliminate its malloc and free overhead
as well, while we\'re at it.**

The default memory management strategy for a region is to use the
**heap**, which uses malloc and free under the hood.

We can make it so a certain region uses **pool** allocation, which is
*much* faster. Pool allocation will cache all freed structs for future
allocations of the same type.

Functions can also use **arena** allocation, where we instead use a
large \"slab\" of memory, and we keep allocating from the next part of
it. Whenever it runs out, Vale allocates another slab of memory. This
can push performance *even faster*, though one should be careful when
using this, as it could destroy the heap. Fun fact: the pool allocator
is built on top of the arena allocator, under the hood.

Pool allocation\'s benefits:

-   It\'s *extremely* fast, because instead of an expensive call to
    > malloc, allocation is simply incrementing the \"bump pointer\" in
    > the underlying slab.

-   It\'s very cache-friendly, because all of our allocated objects are
    > right next to each other.

-   In release mode, we can *completely* optimize out all constraint
    > reference counting to references inside the pool region, with no
    > loss to safety.

-   We pay no cost to deallocate, because we deallocate it all at once
    > at the end of the function!

Pool allocation\'s costs:

-   Since we cache these structs, our memory usage could be higher. For
    > example, if we make 120 Spaceships and let go of 20 of them, those
    > 20 will still be using up memory. That\'s why pools are useful for
    > the span of certain functions, and not the entire program.

-   Moving objects between regions (e.g. when returning from an implicit
    > lock function that uses a pool region) requires copying those
    > objects.

Used well, a pool allocator can drastically speed up a region.

+-------------------------------+--------------------------------------+
| For example, we could use     | pure fn findNearbyUnits\<\'i         |
| pool allocation for this      | **pool**, \'r ro\>                   |
| basic breadth-first-search    |                                      |
| algorithm, that checks for    | (world **\'r** &World, origin        |
| units at every nearby         | Location)                            |
| location.                     |                                      |
|                               | \'i List\<\'r &Unit\> \'i {          |
| Using pool allocation with an |                                      |
| implicit lock is often called | result = List\<\'r &Unit\>();        |
| a **pool-call.**              |                                      |
|                               | exploredSet = HashSet\<Location\>(); |
| We use the keyword pool after |                                      |
| the region declaration \'i.   | unexploredQueue =                    |
|                               | Queue\<Location\>(origin);           |
| A List uses up to 2x as much  |                                      |
| memory in a pool allocator,   | unexploredSet =                      |
| so this function takes twice  | HashSet\<Location\>(origin);         |
| as much memory, but it is     |                                      |
| also *much* faster.           | while unexploredQueue.nonEmpty() {   |
|                               |                                      |
|                               | // Get next location, mark it        |
|                               | explored.                            |
|                               |                                      |
|                               | loc = unexploredQueue.pop();         |
|                               |                                      |
|                               | unexploredSet.remove(loc);           |
|                               |                                      |
|                               | exploredSet.add(loc);                |
|                               |                                      |
|                               | // If there\'s a unit here, add it.  |
|                               |                                      |
|                               | if ((u) =                            |
|                               | world.unitsByLocation(loc)) {        |
|                               |                                      |
|                               | result.add(u);                       |
|                               |                                      |
|                               | }                                    |
|                               |                                      |
|                               | // Add nearby locations we haven\'t  |
|                               | seen yet.                            |
|                               |                                      |
|                               | newNearbyLocs =                      |
|                               |                                      |
|                               | world.getAdjacentLocations(loc)      |
|                               |                                      |
|                               | .filter({ not                        |
|                               | exploredSet.contains(\_) })          |
|                               |                                      |
|                               | .filter({ not                        |
|                               | unexploredSet.contains(\_) })        |
|                               |                                      |
|                               | une                                  |
|                               | xploredQueue.addAll(&newNearbyLocs); |
|                               |                                      |
|                               | u                                    |
|                               | nexploredSet.addAll(&newNearbyLocs); |
|                               |                                      |
|                               | }                                    |
|                               |                                      |
|                               | ret result;                          |
|                               |                                      |
|                               | }                                    |
+===============================+======================================+
+-------------------------------+--------------------------------------+

**We just made ref-counting free** for our findNearbyUnits function, and
completely avoided malloc and free overhead.

-   References into the \'r region are free because it\'s read-only.

-   References into the \'i region are free because it uses pool
    > allocation.

The only memory overhead we pay is when we copy findNearbyUnits\'s \'i
List\<\'r &Unit\> result from the pool region into the caller\'s region.

Because Vale makes it so easy to optimize with pool allocation, Vale
could become the obvious choice for performance-critical software.

## Fast and Safe

Vale uses single ownership and region isolation to optimize its
reference counting, and then offers read-only regions and
pool-allocation for when we want to eliminate it altogether.

With these, Vale can be 100% safe, while also being one of the fastest
languages in existence.

**Notes**

\"for mutable objects; immutables are shared and so always have
reference counting overhead.\"

**Arena Allocation and Garbage Collection**

Other languages (such as Java) use garbage collection, which
periodically (and sometimes in parallel) scan your object graph and
determine which objects are still alive, and then throw away everything
else for free.

Garbage collectors use an arena allocator their allocations, and
periodically copy any surviving objects out of the nursery and into main
memory. For this reason, GC\'d languages excel in cases where we
allocate a lot, but only a few objects are alive at the end\... just
like our findNearbyUnits function above.

Unfortunately, garbage collection uses long, nondeterministic pauses,
because they do this for the entire heap, not just a well-encapsulated
pure function like findNearbyUnits.

Vale\'s method gives us some of garbage collection\'s benefits without
getting its drawbacks; we only scan the objects that are returned from
implicit locks, and it\'s deterministic.

Because we never deallocate inside the function, it uses *much* more
memory, and if used unwisely, could keep consuming memory until we run
out and start
[[thrashing]{.underline}](https://en.wikipedia.org/wiki/Thrashing_(computer_science)).
