(not sure if any of this is true at all. not even sure how to determine
if its true)

talk about how we dont give you control over the bits, for this reason:
the compiler is better at figuring out savings most of the time.

when doing an imm interface that\'s not exported, it can figure out if
all the subclasses are tiny, and if so, can pack them into a 32 bit
chunk. itll actually rearrange things such that if there\'s a pointer,
itll be at the end, so we can use the low 8 bits as possibilities for
the interface. for example:

sealed interface ILocalVariable2;

struct AddressibleLocalVariable2 {

id: VariableId; variability: Variability; reference: Reference2; }

impl AddressibleLocalVariable2 for ILocalVariable2 {}

struct ReferenceLocalVariable2{

id: VariableId; variability: Variability; reference: Reference2; }

impl ReferenceLocalVariable2 for ILocalVariable2 {}

struct AddressibleClosureVariable2 {

id: VariableId; understruct: StructId; variability: Variability;
reference: Reference; }

impl AddressibleClosureVariable2 for ILocalVariable2 {}

struct ReferenceClosureVariable2{

id: VariableId; understruct: StructId; variability: Variability;
reference: Reference }

impl ReferenceClosureVariable2 for ILocalVariable2 {}

it\'ll actually pack the variability enum in with the understruct
pointer, since it knows that there\'s only two values for variability.
It\'ll also move reference to the end, and note that the last 3 bits of
the struct are empty, if anyone wishes to use them. Basically, this
entire struct can be compacted brilliantly. This is important because
it\'s more important to pack structs tightly for cache reasons. Doing
some bit math is easy and the processor does it in nanoseconds, but
grabbing another cache line is incredibly expensive.

also, if we can keep it under 32 bytes, then we can inline it, which
means no expensive atomics.

another pattern: the bridge method.

the built-in Map object is quite amazing. it\'s a 32 bit structure:

struct:(K, V) Map {

(unused): Int;

mut count: Int;

mut capacity: Int; (shifted 1)

void\* middle;

}

if the last byte in the thing is 0, then it knows it\'s got no space,
and it\'s a pointer to the heap for everything.

if the last byte in the thing is 1-15, then that minus one is the number
of keys inside this map. we can fit 15 chars, 12 shorts, 7 i32s, 5 i48s,
3 i64s. most keys will be i32s, so we just got .contains() for free
basically.

in fact, we can have the compiler guarantee that the low 5 bits will be
empty, by enforcing that all string allocations occur on a 32 byte
alignment. which works well, because the only time something goes to the
heap is when its \>30 bytes.

that means the last byte is 1-31, which means we can have 30 chars, 15
shorts, 7 i32s, 5 i48s, 3 i64s. so really we get a bit more chars or
shorts.

this is not a systems programming language, it\'s an app programming
language. in app programming languages, there\'s a lot of diverse logic
spread out everywhere, and not many hotspots. giving the compiler
freedom is awesome, because we get a ton of tiny gains across the board.
and when we really need to optimize, we can opt-out of any compiler
magic by saying inl and far.

(not sure if true, compare the languages)

cone for example makes you make choices up front (see imm vs const for
globals). V lets you make those choices later (you can leave it off, or
specify inline vs in global memory).
