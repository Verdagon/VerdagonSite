Talk about how we can use resilient mode to start, then normal mode in
development, then fast mode.

talk abt how normal mode is for avoiding useafterfree crashes in
resilient mode

and when using pools, using the wrong data (can happen in malloc too)

talk about how experienced devs will use normal mode by default

talk abt how we can mix and match per module

can whitelist per class, maybe per var?

Say the speedup. Also say, in Vale, we must specifically whitelist which
of our dependencies can use unsafe references. maybe even say we\'ll be
trying to close the gap between resilient mode and fast mode, but we\'ll
reveal that to the world much later. say

fuuuuck we need to have a separate heap for basically every type if were
gonna do this crazy thing. but, only if something has inlines. anything
not inlined can share a heap with anything else of the same size class.
goodness, we basically need pools for every size class, and every
inlined struct.

the reason is that inlined structs need a generation at their head, and
it has to stay increasing. so if my obj has 5 inl structs, my chunk has
6 ints that need to stay increasing, yikes.

maybe we really can categorize by inl configuration. i bet we save a lot
by doing that. can even encode as a 64b integer, where each bit is a 8b
increment\...

because of all this, the separate global map might still be an okay
candidate, space wise. it wont use too much memory.

\- separate global map of wrcs: very slow, very small

\- separate global map of generations: slow, small

\- pool for every non-inl size class (all w interior generation) and inl
struct (only weakables have interior generation): super fast, medium big

\- pool for every struct type (weakables w global wrc map index): almost
lightning fast, quite big

\- pool for every struct type (weakables w generation): lightning fast,
very big.

\- fast mode, weakables with global map of wrc: almost fastest, unsafe,
smallest

\- fast mode, weakables with global map of generations: fastest, unsafe,
almost smallest

\- fast mode with bump allocation should wreck!

arrays arent a problem because we cant have weak refs to em. but can
have crefs to em\... maybe change that\... or we\'ll have to do some
special thing with mergeable array ranges in the heap or something.

want to asymptotically approach 0xFFFFFFFF.

when we get to 0x80000000, we can switch to a mode where, every time we
get halfway the remaining distance to 0xFFFFFFFF, we\'ve allocd twice as
many generation ints.

that makes some sort of weird curve maybe?

goodness, if we can beat rust\'s cache friendliness with our pooling
alone, then we dont have to deal with the inl-in-vector conundrum.

hopefully our pool calling beats the mallocs rust has to do for its
vecs. but theres a chance it wont. if it doesnt, do the below.

anyway, just do the vale vs c++ comparison first.

then say \"to compare against rust is a bit difficult. with rust, you
cant do quick prototypes, you \*have\* to go straight to the optimal
approach, even if it takes an extra 7 hours. we did those adjustments in
the c++ and vale too.\" (have a note explaining premature optimization
is root of all evil, and how it takes a long time to learn the optimal
way)

and then show the version with the inl things and the integers. gross.

then show it outperforming rust, heck yeah.

if it doesnt, bring the devastation, use generational malloc.

\...wtf\... rusts purpose is safety and speed, but we can just obviate
the entire thing with a slight tweak to malloc and the language. rust
becomes obsolete. instantly.

can we add this to c++? we cant just build this into malloc, we need 8b
at the top of every single obj even if inside another obj. it has to
basically be a base class to every object, like where the vptr would go.
every pointer would have to be a fat pointer, and we couldnt point at
something inside the object; we cant point at a field. not very c++ish.
on top of that, itd be a global atomic map because of shared address
space.

can we add this to rust? i dont think so. can take pointers to things
inside. would need it as a base class to everything. would need to scan
the entire obj.

no, this can only be done by us.

this reduces vales overhead on rc. it wont make us as fast as rust on
its own, but it gets us pretty close. easy pooling could bump us over
the top. and make us the fastest.

also, refs on the outside like in jvm are super easy now, no need to rc,
just have a generation.

this legit makes vale safer AND faster than rust.

we can do this with mimalloc. use it for rust and c++, then do multiple
ones for vale.

just dont call free if the generation gets to 0xFFFFFFFF, let it leak.
better to slow down memory and eventually crash from an OOM than to
crash right away.

maybe free it at the end of main.

if we have a global weak table that uses generations, then we can do
single ownership with null ptr checking for basically free. crap.

constraint refs are good for fast mode which doesnt have the cache
misses in the table to check the generation. but theyre just for
asserts, right?

the generation can live inside the object itself for pool calls.

outside in normal heap, the generation has to be outside, because malloc
doesnt guarantee there will.be an integer at the top of it. we cant
trust free() to not overwrite our generation to be something that makes
sense, and our generational pointers need the guarantee that the
object\'s generation is always increasing. so, the generation must live
outside.

this means that whenever we use a reference, we have to check the
generation is still correct. we can do branch prediction, but the cpu
will still stall if somethings not in the cache. even if we predict
perfectly. luckily this only happens when we actually try to dereference
the object.

we can avoid those stalls with implicit locking, for constraint refs,
because we\'re guaranteed that the thing still exists. we still need to
check for weak refs but we had to anyway.

so constraint refs are nice because when outside, we can just deref
quickly, no need to check\... but they have annoying rc.

constraint refs are nice from implicit locking cuz no need to check a
weak ptr.

if we just used gen refs in regular heap all the time we\'d hit an extra
cache miss cost but not really. we\'d have fetched the thing we\'re
tryin to fetch which we were probably already stalled on.

crap. cpu might be good enough to prefetch the obj data anyway while
we\'re stalled waiting for its generation.

the use of c refs becomes much more nebulous now. which kinda kills fast
mode. maybe we dont need fast mode?

wait, can we make our own heap that preserves generational indices at
the top? just thinks in terms of object size.

vale could be pretty amazing if we didnt need c refs, and just had weak
refs powered by generations. itd mean low overhead, aliasing is free. we
would check somethings wrc before accessing it, but could prefetch the
data we\'re trying to access it so the hit wouldnt be bad. we could also
have that universal reusable heap.

wait, if we lock a weak pointer, we need a constraint ref. we dont want
something dying in the middle of a lock. c refs help a lot with that.
kinda.

maybe we still can have the universal reusable heap, where things have a
generation inside of em. would still need lock ints in them for c refs.
huh, maybe could even share an i64. one could be 40b, one 24b.

so where does that leave implicit locking? well, itd cut down on the
cref counting we would have to do, cuz we do need crefs.

crap, would need to figure out a way to move parts of our thread\'s heap
to another one. malloc solved that, itll be fine.

so, we have a generation num and a crc in each object. special malloc
and free that guarantee ever increasing generation. weak refs are free
to alias, cuz just a generation. when we want to know if obj is still
alive we just check the generation.

we can lock a weak ref with regular cref.

in resilient mode, cref can keep an allocation alive.

the benefit: no wrc table!

but crap, this means we cant send it across a thread,

well, accessing an old instance is fine if we never return it to the OS.
is that fine? we might want a generation table anyway.

single threaded where we copy between threads could be a massive
speedup. maybe have that be an option?

where does that leave us with mutexes? and moving things in and out of
them

maybe this could relegate crefs to just be debugging tools or somethin

if we added this to c++ wed get mem safety and speed yea?
