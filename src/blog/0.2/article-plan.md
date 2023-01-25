To see total users by article and referer, see [here](https://analytics.google.com/analytics/web/?pli=1#/p240039903/reports/reportinghub?params=_u..nav%3Dmaui%26_u.dateOption%3Dlast7Days%26_u.comparisonOption%3Ddisabled&collectionId=3808702886).

See those linking to me: [https://search.google.com/search-console/links?resource\_id=sc-domain%3Avale.dev](https://search.google.com/search-console/links?resource_id=sc-domain%3Avale.dev)


We'll finish most of 0.2, then start posting all these fortnightly.

remove "most memory safe", since we switched to probabilistic safety.

Ready to go:

- ~~On Removing Let and Let Mut~~
- ~~Const generics (just r/vale really, unless we can make it interesting)~~
- ~~Concept functions (everywhere)~~
- ~~Version 0.2 released~~
- ~~Next: Fearless FFI~~
- ~~Next Gen Language Features: User Code on the GPU~~
- ~~Perfect Replayability~~
- A More Memory-Safe Native Language (vale.dev/memory-safe) (done)
- Generational References (redux)
  - Updated design, probabilisticness
  - emphasize that the user decides which reference is the owning reference
  - Talk about inspiration from rust gen indices perhaps?
  - Talk about how this enables more architectural freedom
  - Take out that we deref more. True but dubious.
  - Maybe talk about how it can blend well with the region borrow checker (link to it)
  - Take out RC stuff
- Update HGM, but dont post it anywhere
- Get perfect replayability working on a basic RL, then:
  - First 100k lines (done)
- Thoughts on Language Complexity (drafted)
- Thoughts on Infectious Systems: Async/Await and Pure
- Lessons from Rust for New Higher-Level Languages

Later:

- progressive disclosure: https://www.nngroup.com/articles/progressive-disclosure/
- (some articles on region borrow checker)
- (benchmarks for region borrow checker?)
- thoughts on infectious systems: https://www.reddit.com/r/ProgrammingLanguages/comments/vofiyv/thoughts_on_infectious_systems_asyncawait_and_pure/
- Vale programming language, plans and ambitions for v0.3
- "memory safe single ownership without a borrow checker"
- perhaps show on compilerspotlight like https://compilerspotlight.substack.com/p/language-showcase-gwion

ideas, add these below somewhere:
- "memory safe single ownership without a borrow checker"
- immutable calling, the foundation for an easier and simpler borrow checker
- an article talking about how languages can be more memory safe and still fast. maybe praise rust a little bit to get aligned with the readers' values. talk about HVM, ante, lobster, vale.
- "The async design that took 4 years to solve" on our new hybrid thing
- "Transitioning from Templates to Generics, and my Slow Descent into Madness"
  - why vale is transitioning
  - we're not transitioning all the way; lambdas still behave like templates
  - C++ is actually closest to the ideal right now
  - compile time benefits, the plan for monomorphizing
  - an interface is really just an enum. some weirdness happens when its an open interface, but not much tbh.
- single ownership without a borrow checker
  - talk about how this is what c++ does
  - perhaps also mention lumi
  - it lets us do a lot of new things like better raii, observers, backrefs, graphs, dependency refs
- monomorphizing based on size
- article on UUIDs and the file system, and just crashing if there's a collision. its fine, because it will so rarely happen (but thats )


"the hardest part of designing a language is considering others' ideas"
talk about cardinal and his pushing so hard for a rust-like system
talk about everyone pushing back on the let syntax
but its incredibly important. its so easy to fall into the trap of "i know better than anyone else. im the one with almost a decade at google, who knows everything about programming languages."
but even if i know more, i still only know a tiny fraction of what everyone else cumulatively knows.
i can only hope that more people come forward with their proposals.


"the highs and lows, fears and joys of making a programming language"
talk about how im so afraid to work on regions
perhaps release it once we have some benchmarks though


"some people train for marathons. some people go to tibet for a decade to become a monk. some people start their own programming language."


"Lessons we can take from Rust into other languages"

Start about now:

- article on how regions can help with errors and panics and stuff
- Colors:
  - article on why function colors are bad
  - talk about how we cannot be generic over function color
  - talk about the monomorphizing problem leading to code size explosion
    - or it leads to brittle breaky APIs
  - talk about how it can become even more catastrophic once you go through Option's map function for example
  - talk about how it's potentially even a problem in vale's read-only regions
  - talk about how we intentionally move the purity checks to runtime
  - reference [https://gavinhoward.com/2022/04/i-believe-zig-has-function-colors/](https://gavinhoward.com/2022/04/i-believe-zig-has-function-colors/)
  - the alternative (such as vales new threads) are more decoupled. function colors are less decoupled.
  - can we tie in composability?
- The Next Decade in Languages, Part 1: Regions

Language Simplicity Manifesto

- First, do some posts. first to r/programminglanguages, then r/programming.
- Then do a series about it?
- How a region-based borrow checker can ease the learning curve
- Later on, do Thoughts on an Automatic Rust, Part 1

Perfect Replayability:

- (first, actually make it)
- talk about:
  - rr will let you debug just one execution. pretty nice, but lets go further.
  - we can let you add any vale code you want, as long as it doesnt read anything from FFI. you can completely refactor your entire program.
    - well, you can completely refactor anything that doesnt involve adding threads, probably.
- string's GetHashCode() is nondeterministic in C#
  - then talk about why determinism is cool, and how it helped find a ton of bugs. also talk about 7drl
- New in Vale 0.3: Nondeterministic Replayability
- How We Overcame Randomized Addresses and Eliminated Heisenbugs For Good
- How to Survive Your First 100,000 Lines
- The Fastest User Study of All Time - talk about the right click, and how we had no idea what he did until way later. if we had recorded it, we would have known lol

wait until we have a much more rock solid portrayal of vale's direction. look over the notes from that angry guy again, just to be sure. redo the comparisons page.

Reluctantly making my case against the object borrow checker:

1. EC vs ECS in Roguelikes
2. Hidden costs of borrow checking too far, part 1: Basic Observers
  - talk about how the hardest part of learning rust is when to follow the borrow checker's lead, and when to work around it. we all know that it's conservative, that it rejects safe patterns. but we dont often see anyone discussing those patterns. this article will discuss one of those.
  - talk about how there's the occasional rust user that will never use any borrow checker workarounds. they will try \*anything\* else, even if it incurs a lot of complexity.
  - im not saying we should always use Rc. im not saying we should always use RefCell. im not saying we should always use unsafe. im not saying we should always use Cell, when its available. The real answer is a lot more nuanced, as we all know.
  - i'm thankful for the parts of the rust community that are willing to discuss these aspects openly and honestly, i always enjoy working with people like that.
  - i encourage people to not say "this is easy. just learn to rust better. just do XYZ." we all know the solutions here. this is an analysis and discussion of the challenge itself.
  - i hope that this article will enlighten people on the architectural factors of leaning too hard on the borrow checker, spur some constructive conversation on the best meta-approach for these challenges, and the best ways to communicate them to those just starting to learn rust.
  - link to the observer challenge
    - add a Vec into the accounts, so that they cant be used with Cell.
  - luckily, you can always reshape your architecture to accommodate. though, pushing complexity upwards is the sign that somewhere, your abstractions are leaking. at least its not your fault here, it comes from the borrow checker itself. and rearchitecting gets more and more difficult as time goes on, so you really need to be aware of these drawbacks early on.
3. the observer challenge, post mortem
  - all the approaches really just shuffle the shared mutability problem around
  - all the approaches have more runtime overhead
4. Hidden benefits of borrow checking, part 1: Top-down Architecture
  - basically article-ify that one anti-OO video
  - do this gradually.
  - mention that the region borrow checker will try to get those benefits without the complexity, using iso regions
5. Hidden costs of borrow checking too far, part 2: Custom RAII
6. Hidden benefits of borrow checking, part 2: Pure functions
7. Hidden costs of borrow checking too far, part 3: Dependency References
8. Hidden costs of borrow checking too far, part 4: Delegates and Back References
9. Hidden costs of borrow checking too far, part 5: Graphs
10. Hidden costs of borrow checking too far, part 6: API Stability
  - link to the observer challenge again, talk about how the first course of action would be to refactor that observer lol
  - then talk about how we'd keep refactoring that observer, to infinity
11. Hidden costs part 7: Interchangeability
  - Show a button. itll either use a fake network requester or a real one. but uh oh, when it comes time to add the real one, we need to change the interface to hand in a real network manager! but we dont have one! now we cant hold onto our request, aww. that would have been nice, so it could automatically be canceled when we go out of scope. now we're vulnerable to that kind of data inconsistency bug.
12. The cycle of programming language religiosity, from OO to FP to Borrow Checking
  - [https://discord.com/channels/@me/609631444003717135/972332091859664907](https://discord.com/channels/@me/609631444003717135/972332091859664907)
13. Paradigm synthesis, and how to make a balanced programming language
14. an article on why i dont trust the borrow checker when taken to its extreme. link to all of the above. mention how we don't know if the region borrow checker will do any better. we suspect it will, because it generally gives more freedom, but we'll see. also emphasize that this is why rust offfers escape hatches, good lang design.

Steps towards an easier rust

article: the borrow checker is at odds w raii

we should put a particular focus on interesting graphics and good titles. i think that helped the last couple articles. maybe do some light experiments with colorful graphics? like Processing did for java, thatd be cool.

good code is meant to be updated and fixed. if things are nicely encapsulated, you can sometimes fix it in just one spot, because you dont need to worry about constraints elsewhere.

but as soon as you add more constraints, you cause refactoring shockwaves. and refactors cause, you guessed it, more bugs.

when youre choosing a language, you gotta ask: do i want 20% more features to grow your userbase more exponentially, or 20% more speed which translates to 3% more cost? IRL, the answer is almost always features.

when rust keeps us from certain techniques, our code necessarily becomes more complex.

there are very likely situations for which those techniques make for the sinplest code. so by necessity outlawing those techniques makes for more complex code. for example, raii and observers.

"Rethinking the borrow checker for ease-of-use"

maybe write an article on how raii helped us not drop a terrainpresenter without destroying a unit

An article on how we still have shared mutability of a sort, and we dont know it but we \_really\_ want the compiler to more precisely support us in that endeavor.

"Towards an easier rust"

could explain what vale does, and ask them to figure out how to make rust do it lol

title: "first look: ..."

theme: exploring whats possible in PLs

in an article, talk about how its fine to only deal with 20% of a language on a daily basis, and leave the other 80% to the more hardcore cases. its more desirable than making everyone use 100% of the complexity everywhere.

"Combining the good parts of Rust and C++"

safety of rust w flexibility/raii/di/observers of c++

What Rust Teaches us for Vale: Destructors

"Java's metaphorical `unsafe` block"

talk about com.misc.Unsafe

talk about how java could have had fearless FFI

mention vale is going for that

maybe also mention javascript

"Destructor parameters in Rust, C++, and Vale"

talk about how c++ usually has members for it

vale can do it just fine

rust needs to escape the borrow checker

was an article submitted to HN today (apr 4) titled "USB-C hubs and my slow descent into madness (2021)"

i love that title.

we should make something like:

"Learning too many programming languages and my slow descent into madness"

General strategy:

- Get a wide general audience via r/programming and HN
- Interest fellow language enthusiasts on r/programminglanguages, maybe some will help
- Interest hobbyists on r/roguelikedev and r/gamedev, to build ecosystem
- other communities?

[Peripheral Articles](#_bs2yuwp51lw7)

[Surprising Weak References, Redux](#_5hfalbs5iwo1)

[The Zero Overhead Function](#_op3go19jo9l)

[What I Told 4,000 Nooglers About Impostor Syndrome](#_3zqd3dkhn0sd)

[Single Ownership, from a C Perspective](#_h84lgotvp69g)

[Single Ownership, from a GC Perspective](#_r0luheok9ezw)

[When to use \&lt;\&gt; for generics](#_ti2eusjsjf46)

[Enums are Really Just Interfaces](#_v21dv2axjfh9)

[Infix Calling](#_1m6djq3fw0oo)

[A Compiler's First 100,000 Lines: Lessons Learned](#_xnz7rn20gbyh)

[Declaration and Mutation Statements](#_4t734mgra9mp)

[Aspect Monomorphization](#_x9mddjnwsnoz)

[Inline Data, using GC, RC, and Gen Refs](#_ugdan0lc0gkr)

[UB Isn't Necessarily A Long-Term Problem](#_r6e6c7fitkjl)

[The Next Decade in Language Design](#_2fshd28xg2sy)

[Borrow Checker's Real Purpose](#_y61ahmy2iy9f)

[Monomorphizing Const to Immutable](#_wk387iomekib)

[The Language Simplicity Manifesto](#_a02i6mqlb9um)

[Language Simplicity Manifesto](#_xfm560ajm9ye)

[Language Simplicity Manifesto: Measuring C++](#_5cjkzk6uy73u)

[Language Simplicity Manifesto: Measuring Rust](#_ogtnk8v5e0j0)

[Language Simplicity Manifesto: Measuring Haskell](#_5yo3126h3kfv)

[Language Simplicity Manifesto: Measuring Vale](#_2vm3p16rzd22)

[Semi-Peripheral Articles](#_4qftzrpr4rem)

[How to Survive Your First 100,000 Lines](#_at6z0y73m3fw)

[Single Ownership: Faster than GC and RC](#_1w4hkk1sl397)

[Single Ownership Can Be Easy](#_mzmnnld7dxh4)

[How to Not Need Default Values Or Null](#_cgwsr6q6xbde)

[Rust Should Add Super-Immutable](#_i9q3fjh5hnuj)

[Opt-in Complexity: Python vs C#](#_d7yzn5u45xxk)

[Surprising Weak Ref Implementations: Vale, Swift, ObjC, Rust, C#](#_ppf2ur6n63zv)

[Reentrancy in Compilers](#_4f8sihuooi6d)

['This' is not special](#_ptdzusiibs18)

[Safety and Speed without Borrow Checking](#_75ay505jn97c)

[Pure Functions without Viral Coloring](#_5dhw9bwfhqkz)

[How to Write a Really Slow Compiler](#_nycl14d2h3r6)

[Decouple Allocation from Logic](#_38281xesjc46)

[Move past the dogma, make a great memory model](#_8rkwuje2ny1n)

[Move past the dogma, make a great language](#_k4pn2jroeph)

[There's lots of space left to explore](#_f28lu7mtyu3o)

[Learning from the borrow checker](#_gcyio05upu5o)

[Rust is just the beginning: Advances in speed and memory safety](#_3txmoppyswdi)

[We Turned Generational-Arena into a Language](#_uu7og1dqf8ol)

[Automatically translating generics to Golang's interface{}](#_kuskvitgh6vq)

[The Journey to HGM](#_8cfamccoj14d)

[Honest conversations on the fundamental benefits and drawbacks of Rust, Part 1: Shared Mutability](#_52vovfd6me26)

[The Quest for an Automatic Rust](#_on5mgikudnvc)

[The Quest for an Automatic Rust, Part 1: The Actual Strengths](#_ms670ye9672b)

[Thoughts on an Automatic Rust, Part 2: Unique References](#_g9xatqtc6ujw)

[Thoughts on an Automatic Rust, Part X: Handles](#_ywbzgphztxhq)

[Thoughts on an Automatic Rust, Part 3: Aliasability-xor-Mutability is a Distraction](#_cz7tbi8mah3u)

[Thoughts on an Automatic Rust, Part 4: Guarded Borrows](#_lujklx9hfx36)

[Thoughts on an Automatic Rust, Part 5: Aspect Tracking](#_aw325i0xp3s)

[Thoughts on an Automatic Rust, Part 6: Copies](#_nbjfiqjac6kp)

[Thoughts on an Automatic Rust, Part 7: Putting it All Together](#_w15t2h1wefws)

[The Memory Safety Grimoire](#_qepasmb164ve)

[(40 Grimoire Docs)](#_ya6ad02qp5lq)

[Vale Design Philosophy](#_yuzyqsmnm3h3)

[(21 Vision Docs)](#_yt4rc84jvptu)

[Why Vale Wont Have Unsafe Blocks](#_2w23wm7hsq9)

[Why Vale wont be adding Rust's borrow checker](#_ia9rhn3h8s1h)

[Simplifying A Language](#_r15eym5jahxn)

[Rust and C++ Ideals Above Systems Programming](#_p798pl1gvdwt)

[One Language To Not Rule Them All](#_i58lbovyog07)

[Encouraging People to Try Vale](#_6t1eubca6sui)

[Pentagonal Cellular Automata in Vale](#_d5w4b3je44c7)

[Software Engineering in 7DRL](#_fkf1t6kjz49y)

[Type-state Programming in Vale](#_6xqg212b0j7q)

[How region-based borrow checking can enable better structured concurrency](#_28sg0fa35dbx)

[How region-based borrow checking can enable better architecture](#_v6msxglbfkgb)

[How region-based borrow checking can ease the learning curve](#_194n89ijz49v)

[How region-based borrow checking can speed up our code](#_w8an0ypncmt7)

[Domino 1.0: Elevation, Polygonal Tiling, Symbolic Graphics!](#_a3ugdo2qaggm)

[Pentagonal Cellular Automata in Vale](#_i9fn854ia8ua)

[Vale 0.2.1: FFI without unsafe, Modules, Standard Library](#_bel4nz4upub9)

[Vale 0.2.2: Deterministic Replaying](#_3ol0lv4wql9s)

[Handling Roguelike Complexity, Part 1: Deterministic Replaying](#_jkxqf6pgjzjh)

[Language Features for Roguelike Development](#_z5jq7stqprkz)

[Vale 0.2.3: Region Borrow Checker](#_d0uxniinx3yn)

[Handling Roguelike Complexity, Part 2: Pure Functions](#_gdms8obkr5oe)

[Vale 0.2.4: Constraint References, Weak References](#_gc6jrzu9whhc)

[Handling Roguelike Complexity, Part 3: Assertions and Constraint Refs](#_2yj5e6q7j3mn)

[Handling Roguelike Complexity, Part 4: Random Player](#_4se0q6kf1c7d)

[Handling Roguelike Complexity, Part 5: Entity-Component-Interface Architecture](#_l8nhqea5536l)

[Gen Refs vs RC/GC/BC](#_9ph5jni8br1m)

[Where Could Vale Fit into the World?](#_rky5rtl9fwvp)

[Single Ownership Can Be Easy](#_5lnvykirjqyy)

[Performance-Sensitive != Low-Level](#_uf038bqnnj0o)

# Peripheral Articles

These are articles that:

- Are a benefit to people who aren't even that interested in Vale. They stand on their own, and only mention Vale in passing.
- Don't raise the stressful question of "is this thing youre talking about ready yet?" and stalls it for a while, yet still tells people of our approaches and philosophy.

## Surprising Weak References, Redux

sometime soon: update the HGM article and add a note to the top of weak references saying this is out of date, and we'll be using chaining instead

## The Zero Overhead Function

the same article mentioned in the yak shaving article, go into more detail about it

## What I Told 4,000 Nooglers About Impostor Syndrome

(not really related to vale but w/e)

article: what i told 4,000 nooglers about impostor syndrome

article about how my favorite thing about google was teaching the developer workflow classes, i quit google so that i could work on vale and have a much broader reach

then tell them the story about that time at that lunch

tell them how we all have different strengths

the noise in the room is very much from the few geniuses, and people talking about the narrow skill theyve mastered

everyone else is pretending. there are no experts, just people playing the part.

maybe thats okay. its better to have a direction, even if its only semi-informed

## Single Ownership, from a C Perspective

(SOFCP)

See blog/single-ownership-from-c-perspective

## Single Ownership, from a GC Perspective

(SOFGCP)

See blog/single-ownership-from-gc-perspective

## When to use \&lt;\&gt; for generics

Mention we're doing it in vale, nothing bad has happened yet.

its part of the style anyway.

myArray[i] is ambiguous with List[int]

Can either do myArray[i] and List\&lt;int\&gt;(...)

or

myArray(i) and List[int](...)

i like myArray[i], it makes it clear we're operating on a local variable.

## Enums are Really Just Interfaces

## Infix Calling

Talk about how it was really easy, just do alternating, and lowest precedence.

## A Compiler's First 100,000 Lines: Lessons Learned

(r/programminglanguages, r/programming, HN)

- technical:
  - use parser combinators. so much fun.
  - dont use functional programming. you are progressively building up an output, FP is not great for that. maybe link to: [https://codewords.recurse.com/issues/six/immutability-is-not-enough](https://codewords.recurse.com/issues/six/immutability-is-not-enough)
  - the method "could something have caught this in the previous stage" and also when something fails look at the simplest earliest test that failed.
- design:
  - dont lock yourself into a decision. if you _think_ something's probably the right choice, but its permanent, go the other way so you can try it out for a while.
  - when trying out a new tool, try _only_ giving that tool. you might be surprised to find its powerful enough to not need help (single ownership) or have a better understanding of what help it \*really\* needs.
- mental:
  - talk about how youre always in the details, the edge cases, the part that are weird. but, those are the parts that like, 0.01% of people will see anyway.
  - when you program in your own language, you see how beautiful it really is, because youre coding it like the average coder.
  - everything your write is throwaway code. get used to this early on. what youre really building is the expertise.
  - keep an eye out for isolated projects: small, medium, large. these will be great for onboarding people.
  - its difficult to work on a language when people keep asking you "why do this when rust/zig/nim already exist". gotta keep goin!

## Declaration and Mutation Statements

need a better title

- talk about how we use a = 5; to declare, and set for modifying. i encourage all langs to do this!
- count up how many mut are in vale code

## Aspect Monomorphization

- We can monomorphize based on the _size_ of T
  - rust might do this?
  - C# might do this
- We can monomorphize based on whether a specific param expects a scope tether
- We can monomorphize based on whether a region expects scope tethering
- We can do this through interfaces, because we know a particular method has a finite, known set of versions
- We can even have a "poly" version, where it's not monomorphized, where it's type erased.
  - As long as it's compatible with all the expectations of everything.
  - In vale, it has to do a _lot_ more gen checks. Still 2.3x faster though =)
- We can even switch back and forth between poly and the monos!
  - The poly might have a jump table at the beginning to switch to a more specialized version of itself.
  - When a mono needs to call a poly, it just does, no table needed.

## Inline Data, using GC, RC, and Gen Refs

Encourage other languages to do this too

## UB Isn't Necessarily A Long-Term Problem

[https://discord.com/channels/398263331808346123/884913138271658004/884918358489841744](https://discord.com/channels/398263331808346123/884913138271658004/884918358489841744)

talking about how we cant do something because its UB. but its just an LLVM problem really. if we move off LLVM, suddenly its not UB!

but also talk about the cost of consistency across CPUs. some CPUs need extra instructions to wrap properly.

## The Next Decade in Language Design

Talk about upcoming things like verona, vale, cone, zig, nim, odin, etc.

orca

talk about immutability. perceus and HVM are both major strides in this area. maybe also talk about the region borrow checker? and maybe about how isos can become imm, i think pony did that first. maybe also talk about how the region borrow checker lets imm things point outward at mutable things? maybe also lament that swift shared its objects across threads, otherwise it would be in an awesome position to take advantage of this.

allocators

## Borrow Checker's Real Purpose

- We don't want a mutable borrow reference at the same time as any other mutable reference.
- Except we _really_ just don't want any borrow reference while it's deallocated.
- Except we _really_ just don't want to _use_ any reference while it's deallocated.
- Except we _really_ just don't want to use any reference after it's been reuse.
- Except we _really_ just don't want to interpret any non-T pointer as a T.

Let's not get fixated on aliasability xor mutability. It's just a useful approximation, a good starting point.

## Monomorphizing Const to Immutable

[https://www.reddit.com/r/ProgrammingLanguages/comments/stg4ya/comment/hxlbgcl/?utm\_source=reddit&amp;utm\_medium=web2x&amp;context=3](https://www.reddit.com/r/ProgrammingLanguages/comments/stg4ya/comment/hxlbgcl/?utm_source=reddit&amp;utm_medium=web2x&amp;context=3)

# The Language Simplicity Manifesto

## Language Simplicity Manifesto

## Language Simplicity Manifesto: Measuring C++

## Language Simplicity Manifesto: Measuring Rust

## Language Simplicity Manifesto: Measuring Haskell

## Language Simplicity Manifesto: Measuring Vale

# Semi-Peripheral Articles

These are articles that:

- Push a philosophy for other languages, and mention we're also pursuing them in vale.
- Don't raise the stressful question of "is this thing youre talking about ready yet?" and stalls it for a while, yet still tells people of our approaches and philosophy.

We should probably have donations setup before posting these.

## How to Survive Your First 100,000 Lines

## Single Ownership: Faster than GC and RC

(SOFGCRC)

talk about inline data, how it enables CPU prefetching, and so on.

## Single Ownership Can Be Easy

(SOCBE)

- references SOFCP and SOFGCP for what single ownership is

explain how rust and c++ are hard, and how RAII is awesome, and we do it better, how GC can't do it

## How to Not Need Default Values Or Null

c++ needs default constructors for arrays

C# structs need zero constructors wtf why

All golang things have zero constructors, BS

Even rust struggles: [https://www.joshmcguigan.com/blog/array-initialization-rust/](https://www.joshmcguigan.com/blog/array-initialization-rust/)

Scala really shines here

## Rust Should Add Super-Immutable

So that it can really do fearless structured concurrency, like Vale.

Should be a ghost-written article.

## Opt-in Complexity: Python vs C#

- explain what it is
- say that we're trying to stick to these principles in vale

## Surprising Weak Ref Implementations: Vale, Swift, ObjC, Rust, C#

(r/programminglanguages, r/programming, HN)

- [part 2 notes](https://docs.google.com/document/d/1eFQmI5T1ADnXoSptrUly0-FweaM8skJi8zOgCAC1oOo/edit)

## Reentrancy in Compilers

Talk about how reentrancy can be scary.

[https://discord.com/channels/398263331808346123/734119355490762882/863482800442966086](https://discord.com/channels/398263331808346123/734119355490762882/863482800442966086)

Doublecheck definition of reentrancy, there might be a more accurate word for this.

for more ideas, ask on r/rldev, "what are some practices or techniques that helped your roguelike handle complexity?"

"Making use-after-free memory-safe"

## 'This' is not special

- look in all args' envs

## Safety and Speed without Borrow Checking

or "Memory Management, Post Borrow Checker"

i often hear that every language in the future should have a borrow checker. in this article, im going to try to convince you that that's not true.

- HGM; an automatic borrow checker, that either automatically incurs bounds checks or scope tethering or RC or whatever

- region borrow checker; an opt-in borrow checker

- aliasability-xor-shapechanging, a theoretical addition to rust. would be \_amazing\_ for ECS or anything relational.

- Non-Shape-Changing-Memory, which harnesses aliasability-xor-shapechanging. talk about arenas and pools

- Basil's thing

- Lobster's thing, if we added final fields

- colin gordon thing? ask jon about this

- zig's is kind of halfway. but maybe point out the issue i posted, and ARM's stuff, to solve the shapechanging-innards problem

## Pure Functions without Viral Coloring

We dont like accessing globals anyway, so why not.

## How to Write a Really Slow Compiler

tell about the surprisingly slow parts of our compiler, and what we did to speed it up.

mention hashing lol

## Decouple Allocation from Logic

Talk about how we like to do this:

- Zig
- C++
- Rust, maybe
- Odin
- Vale

maybe also talk about how it enables our fast compilation stuff

## Move past the dogma, make a great memory model

(before posting this, ask on r/pl if there are any langs that are mixing memory models, so we can highlight them and vale and cone at the end)

- Good parts of FP
  - everything's immutable, which is cool
- Bad parts of FP
  - everything's immutable, which is stupid
- Good parts of GC
  - compaction
  - we can do manual compaction!
  - dont need global GC, could use actors!
- Good parts of RC
  - deterministic and simple
- Good parts of single ownership
  - can put things in arrays
- Good parts of fortran
  - we declare all our needed space up front! (and maybe a modern approach could spill over into RAM)
- Good parts of the relational model
  - lightning fast iteration

## Move past the dogma, make a great language

(before posting this, ask on r/pl if there are any langs that are mixing approaches, so we can highlight them and vale and cone at the end)

- The internet seems to be divided into three big camps:
  - OO can be pretty nice if used well
  - FP is the one true way
  - Rust is the one true way
- But we're missing a vast space of interesting combinations!
- There are good parts of OO:
  - composition
  - polymorphism
  - encapsulation
  - we think in terms of objects _anyway_
- and bad parts of OO:
  - implementation inheritance can be overused and unnecessarily couple things
- Good parts of rust:
  - can track things other than types in the type system
  - Bring your own overhead™
  - can temporarily freeze things on a per-object basis
  - separating threads' memory
- Bad parts of rust:
  - Borrow checker is very restrictive
  - A lot of your program is spent avoiding the borrow checker (indices, IDs)
    - rust isnt a memory model, its a motivation to find better memory models
  - Can't do polymorphism as well as others
    - no, rust's generics dont count, they pollute the type signature
    - no, idiomatic rust cant handle polymorphism well, polluting parameters
- Good parts of procedural (like zig)
  - simple!
- Bad parts of procedural
  -
- Theres a vast space inbetween!
- also, its totally artificial!
  - FP can do OO! monads are just interfaces! IDs are just refs to mutable objects!
  - Rust is often just FP! we take the world immutably and produce effects!
  - We minimize state in OO anyway, and produce effects! eg my EC AI
- vale is exploring:
  - good OO, since rust neuters it. fun fact: FP has good OO.
  - tracking region via the type system, like rust did, but free of its dogma: we can use more strategies

## There's lots of space left to explore

- See the dogma post
- shape stability!
- regions!
- Safety might be a solved problem soon, with TBI (varying inlines would probably want to be in 16b chunks)
- See elucent's stack-based thing. blend it with RC and actors!
- For example:
  - what if we had a GC'd or RC'd language where pure functions could freeze all existing things? (itd also enable structured concurrency)
  - what if we had an OO language where all transforms were done with FP? (in other words, react)
  - what if we had an actor language with regions, and manual compaction?

## Learning from the borrow checker

celebrate all these great things the borrow checker showed us

inspire them, show them how rust is lighting the way, putting its mark on CS, and making every language better

...and then proceed to highlight good and bad of the borrow checker

- AXM: great on a per-region basis, i think
- we can track non-type things in the type system! this is big!
  - could even track "untrusted" user input maybe?

## Rust is just the beginning: Advances in speed and memory safety

basically just a more positive rephrasing of Beyond Rust

## We Turned Generational-Arena into a Language

post to r/rust

## Automatically translating generics to Golang's interface{}

its all a spectrum!

## The Journey to HGM

Talk about all the crazy twists and turns

# Honest conversations on the fundamental benefits and drawbacks of Rust, Part 1: Shared Mutability

See other doc

# The Quest for an Automatic Rust

## The Quest for an Automatic Rust, Part 1: The Actual Strengths

We went from assembly to C. Lets do that for rust.

Made Vale to learn the lessons from Rust, Scala, C++.

Good things to take from Rust:

- We can iterate over things with ridiculous speed. Takes advantage of CPU prefetching.
  - Arrays will be useful
  - Prefetching is the real goal.
- Inline data
- Hierarchy borrowing
- The rest of the design outside the borrow checker is super nice

Misconceptions to leave behind:

- Rust has no runtime memory safety overhead
  - lol
- Halting is bad
  - Arrays do it. Really, any NONT ref might do it.
- Rc is bad
  - Maybe, but it leaves behind observers, and makes rust terrible for GUI.
- Heap allocation is bad
  - We've just cut off our ability to have trait objects, which are useful
  - No, a one-size-fits-all allocator is bad.
  - After all, what's an array but a specialized allocator

"Idiomatic" is unhelpful.

It'll be challenging for D and C++ to bolt on a borrow checker after the fact.

Promising endeavors:

- Lobster
- Cone
- GM

## Thoughts on an Automatic Rust, Part 2: Unique References

You can have them without a borrow checker.

## Thoughts on an Automatic Rust, Part X: Handles

A handle is basically [vec ptr, id]. This is different than an iterator, which is just a node pointer.

Though, in the case of some data structures that dont move nodes, like linked lists or allocators, they can be the same structure.

We can call .lock() on a handle to get an iterator or a reference. An iterator could be nice because it could lock the underlying data structure and prevent it from changing.

This is nice because it lets us have movable objects, which can be nice.

## Thoughts on an Automatic Rust, Part 3: Aliasability-xor-Mutability is a Distraction

What we're really after is type stability or shape stability.

Imagine if every primitive and unique reference was mutable, like in a Cell. There's nothing unsafe about that.

The real enemy is aliasability-xor-deletion.

In that light, constraint refs are low key startin to make a lot of sense, dont you think?

## Thoughts on an Automatic Rust, Part 4: Guarded Borrows

Talk about how accessing an element will lock the element, accessing an array will lock the entire array.

The granularity of locking is a tradeoff.

RefCell

Scope Tether

Isolate

Remember, arrays still have bounds checking.

## Thoughts on an Automatic Rust, Part 5: Aspect Tracking

Borrow checking is just one extreme, you can track entire regions.

## Thoughts on an Automatic Rust, Part 6: Copies

To get around the borrow checker, we make a lot of little copies.

It's kind of like how in pony etc we copy between threads.

Funny, compared to pony etc, Rust aint a zero cost abstraction.

## Thoughts on an Automatic Rust, Part 7: Putting it All Together

Talk about a few theoretical next steps:

- GM + region borrow checker
- HGM
- HGM with outliving
- Cone
- An RC + refcell + borrowchecking hybrid
- RC + region borrow checker

# The Memory Safety Grimoire

## (40 Grimoire Docs)

# Vale Design Philosophy

These are articles that really start to tell the world about what vale's mission is. We should have donations setup before we post these.

## (21 Vision Docs)

While posting the below, also post the 19 vision docs.

## Why Vale Wont Have Unsafe Blocks

- what unsafe gives up:
  - deterministic replayability, the ability to reproduce any bug you encounter trivially, even in the presence of multithreading
  - cross compilation, so you can use a library from any language and any language can use your library
  - the knowledge that none of your dependencies are introducing a security vulnerability; a much smaller surface area to audit
  - no more mysterious crashes related to someone in a dependency (or even your codebase) mishandling a pointer
- what unsafe gets us, but actually doesnt
  - allocators
    - we can do that ourselves
- what unsafe gets us
  - it avoids array bounds checking?
- mention how it can be useful in rust:
  - safe rust has runtime overhead to maintain safety
  - https://ceronman.com/2021/07/22/my-experience-crafting-an-interpreter-with-rust/
  - "Using vector indices is slower than a regular pointer dereference. An arithmetic operation is needed to get the address of the element, but more importantly, Rust will always check if the index is out of bounds."
  - and rust leans _very_ heavily on bounds checks
- we _could_ have a completely-unsafe mode, where we completely turn off all memory safety. could save some memory.

## Why Vale wont be adding Rust's borrow checker

- talk about the borrow checker's costs:
  - polymorphism sucks
  - its difficult, against the gradual complexity ideal
  - it does have runtime costs, in bounds checks. makes me wonder, is there something better out there?
    - hence exploring HGM
    - hence exploring TSM

## Simplifying A Language

(r/programminglanguages)

- Talk about how complexity skyrockets later on.
  - Examples: C#, Rust, C++
- Early on, simplify drastically.
- What I removed from Vale:
  - readonly vs readwrite
  - imm vs mut
  - variability on locals

## Rust and C++ Ideals Above Systems Programming

(r/programminglanguages, r/programming, r/rust, HN)

- How much I love rust
- I think we can make an even better rust for certain use cases
- and its so complex for beginners! if only there was a way to do the borrow checker automatically. we can! HGM does borrowing + generations for us:
  - expand aliasability xor mutability to aliasability xor shapechanging
  - enums -\&gt; inl varying sealed interfaces
  - add generations to every allocation
- opt-in complexity (link to opt-in complexity article)
  - region borrow checker
  - inl vs heap
  - complexity is okay if the compiler can suggest a fix

## One Language To Not Rule Them All

- Vale isn't that, and it's not trying to be that!
- One should use the best language for the job.
  - Benefit: better fit.
  - Drawback: interoperability
- Example of how this went good:
  - generics is a sub-language
  - pattern matching is a sub-language
- Some interesting experiments
  - Zig's comptime
  - Vale's metaprogramming

# Encouraging People to Try Vale

## Pentagonal Cellular Automata in Vale

## Software Engineering in 7DRL

possible better titles:

- How to do Twice as Much in Hackathons

you can pull off some truly amazing scope if you come at it like an engineer

not like, "lets make perfect elegant robust code" engineer, but a "lets make intentional, informed, and pragmatic choices about trading off investment and accruing technical debt"

for example:

- completely drenching one's code in assertions

- keeping your code deterministic, to more easily reproduce bugs

- using fuzzing to find bugs

## Type-state Programming in Vale

## How region-based borrow checking can enable better structured concurrency

basically a rehashing of seamless structured concurrency

## How region-based borrow checking can enable better architecture

Talk about the iso object

## How region-based borrow checking can ease the learning curve

Talk about how it blends shared mutability in at the must fundamental level

**"I love the borrow checker, but i don't necessarily agree with how Rust uses it."**

## How region-based borrow checking can speed up our code

thisll be tricky, because of the elephant in the room of rust. could be worth it to salesman it.

## Domino 1.0: Elevation, Polygonal Tiling, Symbolic Graphics!

(r/roguelikedev, r/gamedev, r/programming, HN)

- officially released!

## Pentagonal Cellular Automata in Vale

(r/roguelikedev, r/gamedev, r/programming, HN)

- show a vale pentagonal terrain generator
- "we want to grow domino, join us to help out!"

#

## Vale 0.2.1: FFI without unsafe, Modules, Standard Library

(r/programminglanguages, r/programming, HN)

- explain how it works
- why its so cool
- C can still smash the stack, and we'll soon have it switch to a different stack.
- note we dont have inls in vale
- note we cant have refs into host yet
- talk about how this is only possible with generational references, because of DEPAR.

## Vale 0.2.2: Deterministic Replaying

(r/programminglanguages, r/programming, HN)

"Solving the Heisenbug Challenge"

- how it works
- its potential: cross-platform, cross-machine
- floating point troubles

## Handling Roguelike Complexity, Part 1: Deterministic Replaying

(r/roguelikedev, r/gamedev)

- Roguelikes take very little input; some user input, some files.
- Hit a ton of assertions, replaying meant I could add printfs.
- Examples of inherent nondeterminism: time() and user input. These are fine. Record the results of these into a file, and have a flag that will make you read from that file instead.
- There are also cases of artificial nondeterminism, which you'll need to avoid:
  - C#: Don't use string.GetHashCode(), dont iterate over dictionaries.
  - Rust: Dependencies use HashMap, and Rust forces lots of things into maps, impossible.
  - Python: Dictionaries. Need PYTHONHASHSEED=0 in env
  - C and C++: just dont use pointers as hash keys
  - JS has none!
- **Vale has no artificial nondeterminism, and it records everything for you. If you want to see this in action, check it out.**
- This is a also important in multiplayer games, where multiple machines need to do the same exact calculations.

## Language Features for Roguelike Development

(r/roguelikedev, r/gamedev)

- Over the years, we've identified four main features. We're adding them to Vale!
  - deterministic replayability
  - constraint references
  - region borrow checker
  - bunch - this is the most RL specialized one, suspect could be broader
- We hope to try it out in the 2022 7DRL. Come help us make libraries and tutorials!
- Long term, we hope to build a thriving roguelike community, expand to all hobbyist game dev, then expand to everywhere

## Vale 0.2.3: Region Borrow Checker

(r/programminglanguages, r/programming, HN)

- how it works
- nice because opt-in
- how it eliminates a lot of overhead
- later on, we'll be using it to spawn arena and pool regions

## Handling Roguelike Complexity, Part 2: Pure Functions

(r/roguelikedev, r/gamedev)

pure functions. minimize the number of functions that are allowed to change the world. sometimes this is obvious, like in A\* and sight calculation. but there's a much more subtle and powerful art here.

your AI code is probably pretty big, and it changes the world. split it into a big function that looks at the world and figures out what it wants to do, and a tiny function that actually makes its desire happen.

- (two more examples)

AI:

- This is one method of doing AI. I've found it reduces complexity. There are others!
- IUnitCapabilityUC produces an IEffect
- We compare IEffects, and the winner gets invoked.

Vale, Rust, and C++ can do this natively.

when you do your AI, use capabilities and desires.

have each desire measured by a strength. it makes it really easy to reason about whats going on.

## Vale 0.2.4: Constraint References, Weak References

(r/programminglanguages, r/programming, HN)

- (this release promotes the improved constraint ref browser from experimental? we def want it sooner than 0.5)
- [Weak References in Vale](https://docs.google.com/document/d/1MjBRaUHCc6KCX57vszwu6XQbMqL7lThqNiVpmds7sr0/edit)

## Handling Roguelike Complexity, Part 3: Assertions and Constraint Refs

(r/roguelikedev, r/gamedev)

Assertions are crazy good, yo.

Every frame, run a ton of assertions. every assumption that you have.

I had a sanity check run at the end of every frame, and it caught an insane amount of bugs.

Sometimes, you want to detect problems more eagerly.

For example, lets say we have a Spirit Link buff. When one dies, the other is no longer spirit linked.

when you kill something, just assert its ref count is 1.

- C++: assert(ref.use\_count() == 1);
- Swift: assert(CFGetRetainCount(obj) == 1);
- Python: assert(sys.getrefcount(obj) == 1);
- In Vale, just use a constraint ref.

This is especially important for caches. There are generally two ways to handle this:

- Every time anyone uses it, require them to assert the existence. This is the "weak reference" approach. C# a boolean, Rust an index, Vale a weak ref.
- At the end (+begin?) of every request, make sure the cache is sane.
- **If you're using Vale, you can use a constraint reference here if you want.**

Any time you have redundant data, make sure an assertion keeps it in sync.

They work really well with deterministic replaying. Regardless of whether assertions are enabled for the end user, you can still get a replay file from them, and replay it with assertions enabled.

assertions everywhere! get in the habit of adding assertions. any time you run into a bug, ask yourself, what assumption did i violate, and where could the program have first noticed that? "its like you add in the instructions, playtesters, this should result in a number between 0 and 42, if its not then something went wrong, please let me know"

## Handling Roguelike Complexity, Part 4: Random Player

(r/roguelikedev, r/gamedev)

- dont add unit tests. dont add integration tests. your game is going to change radically over the course of 7 days.
- goes really well with deterministic replayability, so you can just add the appropriate printfs later, you dont have to wonder "how tf did i get here"

(no mention of vale in this one)

## Handling Roguelike Complexity, Part 5: Entity-Component-Interface Architecture

(r/roguelikedev, r/gamedev)

- This is a type of EC, which is more flexible.
- It's just a HashMap\&lt;id, IUnitComponent\&gt;
  - FindAll\&lt;T\&gt; will go through and see if it implements that.
    - Dont worry, we have a more optimized version further down.
  - Rule of thumb: Never query for a specific component. Any time you're doing FindAll\&lt;T\&gt; for a specific class, ask yourself, whats the minimum I care about?
  - You don't actually want all SpeedRingUC. You want a IAffectsSpeedUC.
  - Now, can make a new class, BootsOfShuffling, that reduces speed. Extensibility!
  - You can make a SwordUC that implements IAffectsSpeedUC, IAffectsDamageUC, IAffectsWeightUC. It's all in one place. Cohesion!
- **Vale has a built-in class called Bunch** that will do this for us. We translated it to C#, but it had to use reflection, which is almost as fast.
- There's a flavor of this which uses events, where we send an "event" structure to all components that want to receive it. The event structure contains a "results" list. The results are sorted.
- I believe this is better than ECS, which doesn't have this abstraction. YMMV.
  - if we want to go further, can talk about how GPUs are not great for everything, they're only great for "embarrassingly parallel" games. some things are inherently unparallelizable (can link to this article when people say that rust \&gt; vale because it forces you into "best practices")

## Gen Refs vs RC/GC/BC

- ~~Nice because gen refs are single ownership and let us do inl stuff~~
  - no, RC and GC can do that with offsets
- it lets us _use the stack!_
- it frees memory sooner.
  - strong RCs will keep the object deeply alive, even if we know we wont need it
  - weak RCs will keep the object shallowly alive, even if we know we wont need it
- it doesn't over-rely on vectors, so we can be a lot more space efficient if we want to.
- Not difficult like borrow checker is!

## Where Could Vale Fit into the World?

- not low-level programming
  - well, you can, if you extern to C (or zig!)
- not scripting
- ahhh yeahhh everything between

## Single Ownership Can Be Easy

- Single ownership lets us...
  - put things on the stack
  - put things in arrays
  - very cheaply manage memory
  - have RAII
- so we want it!
- but its hard.
  - C++ is unsafe and full of footguns
  - rust's borrow checker is pretty restrictive. cant do the observer pattern!
- it would be nice to get its benefits without the language getting in the way!
- enter vale. yeeee

## Performance-Sensitive != Low-Level

"I need a low-level language, and other assumptions"

- In today's landscape of languages, generally:
  - high level = GC or RC
  - low level = unsafe, borrow checker
- GC and RC suffer on the latency side of performance
- for more performance, people go to unsafe &amp; borrow checker
- so we think performance-sensitive = low-level
- i think low-level is systems programming, in other words, interacts with the OS, or the raw bits and bytes.
- i dont think we necessarily need to interact with raw bits and bytes to get performance.
- i dont think we necessarily need systems programming for performance.
- (sneak in that rust has runtime overhead, we need unsafe for real performance)
- i dont _want_ to believe it, because i want performance, without the risk of unsafety and nondeterminism. we really want performant high level langs.
- and luckily, its not necessarily the case, we want to disprove that with vale
  - inl for cache friendliness
  - region borrow checker, immutable regions
  - regions' allocators
  - HGM extending lifetimes for borrowing finals
- re os-specific:
  - we don't _want_ to make os-specific calls, because then our code is os-specific.
- re rust:
  - we don't want to be constrained. we might like observers, which is impossible in idiomatic rust. if you stray from idiomatic and use RC, youll get RC's drawbacks.
- re unsafe:
  - we dont want our dependencies to have unsafe. we like how JS can't cause unsafety.
- AAA games: use ECS. vale offers no overhead for ECS. inl + hgm
- compilers: use region borrow checker. no overhead.
- servers: use arenas. no overhead.
- (apps are an awkward subject for this article, since theyre os-specific and high level, maybe dont go that direction)
