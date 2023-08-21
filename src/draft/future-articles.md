

# Publish Order

digraph {
    # These are ones I could write about but not really excited to, so hiding them
    # WTUFG [label="WTUFG: Whether\nto Use <>\nfor Generics"];
    # WIT4KN [label="WIT4KN: What I\nTold 4,000 Nooglers\nAbout Impostor Syndrome"];
    # HNNDVN [label="HNNDVN: How\nto Not Need\nDefault Values\nOr Null"];
    # EWLACO [label="EWLACO: An\nEasy Way for\na Language to Add\nCustom Operators"];
    # OLWNRTA [label="OLWNRTA:\nOne Language\nShould Never\nRule Them All"];
    # BCRP [label="BCRP: Borrow\nChecker's Real\nPurpose"];
    # ASPMON [label="ASPMON: Aspect\nMonomorphization"];
    # UBINBL [label="UBINBL: Why\nUndefined Behavior\nIsn't Necessarily\nBad for Languages"];
    # HWSV [label="HWSV: How We\nSimplified Vale"];
    # WTEGC [label="WTEGC: When to Eliminate Gen Checks"];
    # WHP [label="WHP: Why Have Panics"];
    # CSILD [label="Code Size in Language Design"];


    layout=neato;
    overlap=false;
    START [label="", fillcolor="#80FF80", style=filled];


    R3 [label="Release 0.3", fillcolor="#FFC0C0", style=filled];
    LK -> R3;

    RWR [label="Ressurect\nWeak Refs", fillcolor="#FFC0C0", style=filled];

    OI [label="Overload\nIndexing", fillcolor="#FFC0C0", style=filled];

    SCP [label="Seamless\nConcurrency\nPrototype", fillcolor="#FFC0C0", style=filled];

    NP [label="Nanothread\nPrototype", fillcolor="#FFC0C0", style=filled];
    SCP -> NP;

    IDP [label="Inline Data\nPrototype", fillcolor="#FFC0C0", style=filled];

    MSAP [label="Memory-Safe\nAllocators\nPrototype", fillcolor="#FFC0C0", style=filled];

    ORP [label="Opaque\nReplayability\nPrototype", fillcolor="#FFC0C0", style=filled];
    SPR -> ORP;

    SPR [label="Stabilize\nPerfect\nReplayability", fillcolor="#FFC0C0", style=filled];
    IDP -> SPR;

    R4 [label="Release 0.4", fillcolor="#FFC0C0", style=filled];
    PAAF4 -> R4;
    SPR -> R4;
    IDP -> R4;

    MUTEX [label="Mutexes", fillcolor="#FFC0C0", style=filled];
    SCP -> MUTEX;

    GLOB [label="Globals", fillcolor="#FFC0C0", style=filled];
    MUTEX -> GLOB;

    APROT [label="Allocators\nPrototyped", fillcolor="#FFC0C0", style=filled];

    UOO [label="Unsafe\nOperator\nOverride\nPrototyped", fillcolor="#FFC0C0", style=filled];

    STM [label="STM Prototyped", fillcolor="#FFC0C0", style=filled];

    LK [label="Linear\nKeyword", fillcolor="#FFC0C0", style=filled];

    BRE [label="Bigger\nRegions\nExample", fillcolor="#FFC0C0", style=filled];






    SMLIMR [label="SMLIMR: Skip\nMutex Lock in\nMutable Regions"];
    MUTEX -> SMLIMR;

    IFORCS [label="IFORCS:\nInvestigating\nFunction\nOverloading\nin Rust, C++,\nand Swift"];
    OI -> IFORCS;

    WSVG [label="WSVG:\nWhere Should\nVale Go"];
    SCP -> WSVG;

    SCBACT [label="SCBACT:\nShould Checks\nBe At Compile Time", fillcolor="#C0FFFF", style=filled];
    START -> SCBACT;
    HLAPA -> SCBACT;

    WLT [label="WLT: Why\nLinear Types"];
    LK -> WLT;

    VFPMSA [label="VFPMSA:\nMemory Safe\nAllocators\nPrototype"];
    MSAP -> VFPMSA;

    WWWSL [label="WWWSL:\nWant Simpler\nLanguages"];
    MTSE -> WWWSL;

    SOWBC [label="SOWBC: Single\nOwnership Without\nBorrow Checking"];
    OOGPBP -> SOWBC;
    SOFGCP -> SOWBC;

    WLSHTGB [label="WLSHTGB: When a\nLanguage Should\nHave Templates,\nGenerics, or Both"];
    R3 -> WLSHTGB;

    HDLSE [label="HDLSE: Design\nLanguage for\nSoftware Engineering"];
    HLAPA -> HDLSE;

    NDLDC [label="NDLDC: Next\nDecade in\nLanguage Design:\nConcurrency"];
    SCP -> NDLDC;

    PAAF4 [label="PAAF4: Plans\nand Ambitions\nfor v0.4"];
    R3 -> PAAF4;

    ACBG [label="ACBG:\nAbstractions\nCan Be Good", fillcolor="#C0FFFF", style=filled];
    START -> ACBG;

    STRP [label="STRP: Solve\nthe right\nproblems", fillcolor="#C0FFFF", style=filled];
    START -> STRP;

    MTSE [label="MTSE:\nMastered Things\nSeem Easy", fillcolor="#C0FFFF", style=filled];
    START -> MTSE;
    PRCOM -> MTSE;

    SUW1K [label="SUW1K:\nSpeeding Up\nw 1 Keyword"];
    SCP -> SUW1K

    # WVDHE [label="WVDHE: Why\nVale Doesn't\nHave Enums"];
    # IDP -> WVDHE;

    HPLDCOI [label="HPLDCOI:\nConsidering\nOthers' Ideas"];
    ERWVHS -> HPLDCOI;

    VPRS [label="VPRS: Vale's\nPerfect Replayability\nStabilized"];
    SPR -> VPRS;

    ADT4YS [label="ADT4YS: The\nAsync Design\nthat Took 4\nYears to Solve"];
    NP -> ADT4YS;

    ERWVHS [label="ERWVHS: The Escape\nRoute, and Why Vale\nHas Semicolons", fillcolor="#C0FFFF", style=filled];
    START -> ERWVHS;

    HRBAO [label="HRBAO: How\nRegion Borrowing\nAvoids Overhead", fillcolor="#C0FFFF", style=filled];
    START -> HRBAO;
    FIBEE -> HRBAO;

    FPRP [label="FPRP: Flexible Perfect\nReplayability Prototyped"];
    ORP -> FPRP;

    HLAPA [label="HLAPA:\nLangs Affect\nArchitecture"];
    SCBACT -> HLAPA;
    PRCOM -> HLAPA;
    BRE -> HLAPA;

    TOIS [label="TOIS: Thoughts\non Infectious\nSystems"];
    SCP -> TOIS;
    
    DCFCB [label="DCFCB: Data\nand Function\nColoring are Bad"];
    OOGPBP -> DCFCB;
    SCP -> DCFCB;
    TOIS -> DCFCB;

    HVSDCFC [label="HVSDCFC: How Vale\nSolves Data and\nFunction Coloring"];
    DCFCB -> HVSDCFC;
    NP -> HVSDCFC;

    USGR [label="USGR: Using\nthe Stack with\nGenerational\nReferences"];
    IDP -> USGR;

    HUTDW [label="HUTDW:\nHow to use tech\ndebt wisely", fillcolor="#C0FFFF", style=filled];
    START -> HUTDW;
    FUGB -> HUTDW;

    DSEAA [label="DSEAA:\nDifference\nEngineering\nArtistry"];
    HUTDW -> DSEAA;

    FUGB [label="FUGB: Fuck You\nGive Banana", fillcolor="#C0FFFF", style=filled];
    START -> FUGB;
    HUTDW -> FUGB;

    PLI [label="PLI: Prototype,\nLaunch, Iterate"];
    FUGB -> PLI;
    HUTDW -> PLI;

    OOGPBP [label="OOGPBP: The\nGood Parts and\nBad Parts of OOP"];
    ECECSR -> OOGPBP;
    DCFCB -> OOGPBP;
    ACBG -> OOGPBP;

    LRNHLL [label="LRNHLL:\nLessons\nfrom Rust"];
    DPRACV -> LRNHLL;
    TOBR -> LRNHLL;
    WLT -> LRNHLL;

    WRSHLT [label="WRSHLT:\nWhy Rust\nShould Have\nLinear Types"];
    WLT -> WRSHLT;

    HPDLMPD [label="HPDLMPD: The\nHardest Part of\nDesigning a Language\nis Moving Past the Dogma"];
    OOGPBP -> HPDLMPD;

    WLDSKAM [label="WLDSKAM: Lang\nDesigners Should\nKnow About Memory", fillcolor="#C0FFFF", style=filled];
    START -> WLDSKAM;

    SWRR [label="SWRR: Surprising\nWeak References,\nRedux"];
    RWR -> SWRR;

    RCIALLP [label="RCIALLP: Rust\nand C++ Ideals\nAbove Low-Level\nProgramming"];
    SCP -> RCIALLP;

    HWRSC [label="HWRSC: How to\nWrite a Really\nSlow Compiler"];
    HUTDW -> HWRSC;
    OI -> HWRSC;

    DIG [label="DIG: Determinism in Games"];
    VPRS -> DIG;

    EPTTV [label="EPTTV: Encouraging\nPeople to Try Vale", peripheries=3];
    IDP -> EPTTV;

    CCFSC [label="CCFSC: Colorless,\nColorblind, Fearless,\nStructured Concurrency"];
    SCP -> CCFSC;

    TCCCR [label="TCCCR: Thoughts\non Colorless,\nColorblind\nConcurrency in Rust"];
    CCFSC -> TCCCR;

    WWSMMPL [label="WWSMMPL: Why We\nShould Make More\nProgramming Languages"];
    OOGPBP -> WWSMMPL;
    FUGB -> WWSMMPL;
    HVSDCFC -> WWSMMPL;


    UDF [label="UDF: Uni\nData Flow"];
    BRE -> UDF;

    PRCOM [label="PRCOM: \nProgressive\nComplexity"];
    TOLC -> PRCOM;
    SCBACT -> PRCOM;
    MTSE -> PRCOM;

    TOLC [label="TOLC: Thoughts\non Language\nComplexity"];
    PRCOM -> TOLC;

    WROBC [label="WROBC: Why\nRegions Over\nBorrow Checking"];
    BRE -> WROBC;

    FIBEE [label="FIBEE: Vale's First\nImmutable Borrowing\nExample, Explained\nStep by Step", fillcolor="#C0FFFF", style=filled];
    START -> FIBEE;
    HRBAO -> FIBEE;

    TIFC [label="TIFC: Thoughts on\nthe Inevitability\nof Function Coloring"];
    SCP -> TIFC;

    FUSAT [label="FUSAT: The\nFastest User Study\nof All Time"];
    SPR -> FUSAT;

    L150K [label="L150K:\n150k Lines"];
    HDNHLP -> L150K;
    HUTDW -> L150K;

    WACN [label="WACN: Writing\na Compiler\nNomadically", fillcolor="#C0FFFF", style=filled];
    START -> WACN;

    ERFEL [label="ERFEL: Evan's\nRules For\nEvangelizing\nLanguages"];
    R4 -> ERFEL;


    NBNSR [label="NBNSR: Notes\non Boats' Notes\nfor a Smaller Rust"];
    SCP -> NBNSR;
    MUTEX -> NBNSR;

    PFCAG [label="PFCAG: WTF,\nVale's Pure\nFunctions Can\nAccess Globals"];
    GLOB -> PFCAG;

    TPINS [label="TPINS: 'This'\nParameter Is\nNot Special"];
    OI -> TPINS;

    LFMSL [label="LFMSL: Fast,\nMemory-Safe\nLanguages"];
    IDP -> LFMSL;

    MSG [label="MSG: Memory\nSafety\nGrimoire", peripheries=3, fillcolor="#C0FFFF", style=filled];
    START -> MSG;

    PBEMS [label="PBEMS: The Paths\nBeyond the End\nof Memory Safety"];
    MSG -> PBEMS;

    HGMJ [label="HGMJ:\nThe Journey\nto HGM"];
    MSG -> HGMJ;

    HDNHLP [label="HDNHLP: How\nDemonic Names\nHelp Large\nPrograms", fillcolor="#C0FFFF", style=filled];
    START -> HDNHLP;

    TLILU [label="TLILU: Three\nLanguages I'd\nLike to Use\nin 2038"];
    SCP -> TLILU;

    IDUGR [label="Inline Data,\nusing GC, RC,\nand Gen Refs"];
    IDP -> IDUGR;

    ECECSR [label="ECECSR:\nEC vs ECS\nin Roguelikes", fillcolor="#C0FFFF", style=filled];
    START -> ECECSR;


    WWPLRG [label="WWPLRG:\nPerfect Lang for\nRoguelike Games"];
    ECECSR -> WWPLRG;

    CGPRC [label="CGPRC: Combining\nthe good parts of\nRust and C++"];
    ECECSR -> CGPRC;
    OOGPBP -> CGPRC;

    STSST [label="STSST: Static\nTyping and\nSuper-Static Typing"];
    LK -> STSST;

    TOBR [label="TOBR: Thoughts\non an Easier Rust", peripheries=3];
    CBMA -> TOBR;
    TOLC -> TOBR;
    LRNHLL -> TOBR;

    CBMA [label="CBMA: Composing\nBorrowing and\nMutable Aliasing"];
    FIBEE -> CBMA;
    BRE -> CBMA;

    LSOL [label="LSOL: A List\nof Single\nOwnership\nLanguages"];
    SOWBC -> LSOL;

    RIPL [label="RIPL:\nReligiosity in\nProgramming\nLanguages"];
    R4 -> RIPL;

    DPRACV [label="DPRACV: Destructor\nParameters in Rust,\nAustral, C++, and Vale", fillcolor="#C0FFFF", style=filled];
    START -> DPRACV;

    SOFGCRC [label="SOFGCRC: Why\nis Single Ownership\nFaster than GC\nand RC?"];
    SOWBC -> SOFGCRC;

    SOCBE [label="SOCBE: An\nEasier Way\nto do Single\nOwnership"];
    LK -> SOCBE;

    NDLDA [label="NDLDA: Next\nDecade in\nLanguage Design:\nAllocators"];
    DAFL -> NDLDA;

    DAFL [label="DAFL: Decouple\nAllocation\nFrom Logic"];
    APROT -> DAFL;


    NDLDRC [label="NDLDRC: Next\nDecade in\nLanguage Design:\nReference Counting"];
    SCP -> NDLDRC;

    NDLDR [label="NDLDR: Next\nDecade in\nLanguage Design:\nRegions"];
    SCP -> NDLDR;

    NDLDB [label="NDLDB: Next\nDecade in\nLanguage Design:\nBorrowing"];
    SCP -> NDLDB;

    WSTGTF [label="WSTGTF: When\nStatic Typing\nGoes Too Far"];
    TOIS -> WSTGTF;

    SOFGCP [label="SOFGCP: Single\nOwnership, from a\nGC Perspective"];
    SOWBC -> SOFGCP;

    WVDHBC [label="WVDHBC: Why\nVale Doesn't\nHave a Borrow\nChecker"];
    OOGPBP -> WVDHBC;

    RAEH [label="RAEH: Try, Catch,\nMutexes, and\nChannels"];
    SCP -> RAEH;

    WVDHUB [label="WVDHUB: Why\nVale Doesn't\nHave Unsafe Blocks"];
    UOO -> WVDHUB;

    APASTM [label="APASTM: Approach\nfor Software\n Transactional Memory"];
    STM -> APASTM;

    HVLDB [label="HVLDB:\nVale Like\nDatabase"];
    APASTM -> HVLDB;

    HTAMP [label="HTAMP: How\nto Avoid Mutex\nPoisoning"];
    APASTM -> HTAMP;

    RIJTB [label="RIJTB: Rust is\njust the beginning:\nAdvances in speed\nand memory safety"];
    LSOL -> RIJTB;
}




To see total users by article and referer, see [here](https://analytics.google.com/analytics/web/?pli=1#/p240039903/reports/reportinghub?params=_u..nav%3Dmaui%26_u.dateOption%3Dlast7Days%26_u.comparisonOption%3Ddisabled&collectionId=3808702886).

See those linking to me: [here](https://search.google.com/search-console/links?resource_id=sc-domain%3Avale.dev)




# Why is Single Ownership Faster than GC and RC? (SOFGCRC)

talk about inline data, how it enables CPU prefetching, and so on.




# An Easier Way to do Single Ownership (SOCBE)

references SOFCP and SOFGCP for what single ownership is

or better yet, dont even mention rust. just talk about how c++ makes it hard. then say that that difficulty isnt inherent to single ownership, we just have to add some generational references. thatll infuriate them lol




# Surprising Weak References, Redux (SWRR)

sometime soon: update the HGM article and add a note to the top of weak references saying this is out of date, and we'll be using chaining instead

say that with our switch to gen refs V2, it's now an open question again how we'll implement weak references


in between the unowned pointer,  which is similar to a raw pointer in C & C plus plus.  this pointer is conceptually week with an assertion that it is still alive when we use it. valgrind does this for us. we might support this kind of reference in vale, but only to weakable objects, so people are aware of the cost.


Inside: Python

https://dev.nextthought.com/blog/2018/05/python-weakref-cython-slots.html

"This example was written in CPython, which uses a reference counting garbage collection system. In this system, weak references are (usually!) cleared immediately after the last strong reference goes away. In other implementations like PyPy or Jython that use a different garbage collection strategy, the reference may not be cleared until some time later. Even in CPython, reference cycles may delay the clearing. Don't depend on references being cleared immediately!"

You can attach Call backs which is kind of cool,  but it does cause a lot of weird effects, see https://hg.python.org/cpython/file/4e687d53b645/Modules/gc_weakref.txt.

DO NOT USE. deterministic until you fuck up and make a cycle, or switch to gc.



Dispose

Java is similar so far. Though, in Java, we often mimic weak pointers in C# with an alive Boolean,  and we manually check whether something is alive in any method on the object.

C# has a much better way of doing that. its dispose method there is a bit that will keep track of whether the object is still alive and then  CLR checks if we are accessing a disposed object.

https://docs.microsoft.com/en-us/dotnet/api/system.objectdisposedexception?view=netcore-3.1

 this is further proof that even in garbage collected languages we could benefit from single ownership.  see the next steps for raii for more on this.

Similar to an unowned pointer.

In fact you can make a week pointer out of this by trying to call tostring and seeing if it throws an exception.





# Progressive Complexity: Rust vs Swift vs C\# (PRCOM)

opt-in complexity?

- explain what it is
- say that we're trying to stick to these principles in vale

maybe work into language simplicity manifesto?

rust sacrificed progressive complexity.

its fine as long as we have clear pointers/todos towards what we can speed up. see demonic names article. i think people should have control over the kind of performance debt they take on.


progressive disclosure: https://www.nngroup.com/articles/progressive-disclosure/


in an article, talk about how its fine to only deal with 20% of a language on a daily basis, and leave the other 80% to the more hardcore cases. its more desirable than making everyone use 100% of the complexity everywhere.


rust is like the framework approach. you must always use the borrow checker, even when it doesnt quite make sense. tie this in to SOWBC and how we dont like frameworks.



# Investigating Function Overloading in Rust, C++, and Swift (IFORCS)




# Why We Want Simpler Languages (WWWSL)

talk about the developer velocity, the realism, etc.

talk about inherent complexity




# Determinism in Games (DIG)

an article about determinism in games, and C#s struggles here

talk about replayability. helps debugging.

fixed point math

RTS needs this


# Speeding Up Things With 1 Keyword (SUW1K)

"speed up cellular automata 4x with 1 keyword" article when we have parallel


# The Memory Safety Grimoire (MSG)

40 grimoire docs, see grimoire.vmd



# How to Design a Language for Software Engineering (HDLSE)


rust sucks. FP solves it with the state monad and lenses.



# The Journey to HGM (HGMJ)

Talk about all the crazy twists and turns

"The memory safety paradigm that imploded nine times, and the hail mary that completed it"



# Three languages I'd Like to Use in 2038 (TLILU)

nice inspiring article

say that my primary goal is to make vale mainstream, but if i cant, i want to trigger the creation of these three languages, which i'll call X, Y, Z.

- RC with regions and inline. nim could have been this, but its creator doesn't believe it's possible.
- C# with regions. verona comes close.
- vale basically. even one that integrates into CHERI or memory tagging. regions are nice for parallelism even if we dont do memory safety.

basically spend the entire article extolling vale lol

might want to wait for regions proof to come out actually.



# Single Ownership, from a GC Perspective (SOFGCP)

See blog/single-ownership-from-gc-perspective



# Whether to use <> for generics (WTUFG)

Mention we're doing it in vale, nothing bad has happened yet.

its part of the style anyway.

myArray[i] is ambiguous with List[int]

Can either do myArray[i] and List\&lt;int\&gt;(...)

or

myArray(i) and List[int](...)

i like myArray[i], it makes it clear we're operating on a local variable.

Mention it's up in the air for Vale. We could do a switch in our one remaining syntactical breaking change.



# Mastered Things Seem Easy (MTSE)

maybe "I've Mastered It, Therefore It's Simple"

honor your pain.



# Writing a Compiler Nomadically (WACN)

A bunch of tips for programming on the go:

 * Leave context clues for yourself, and use some good static typing.
 * Bring a generator with you. Not really a generator, but one of these things. I call it a "yellow dwarf" because it outputs an insane amount of power.
 * Bring a brita filter!
 * Get an unlimited data plan!
 * Get South Dakota residency!
 * Coffee shops are getting *amazing* lately. Avocado toast, egg sandwiches, all sorts of things. Be sure to tip well, and take off if there are no tables available and you've been there for a while, so others can sit down.

Won't be able to do this forever. Posture is a potential problem.

talk about all the dungeons we've found


article on extreme coding
"the race to zero degrees"



# Combining the good parts of Rust and C++ (CGPRC)

safety of rust w flexibility/raii/di/observers of c++

article: combining the good parts of C++ and Rust

talk about how the good parts of c++ are that it doesnt have a borrow checker. can do observers, dependency injection, polymorphism, and it doesnt need to fall back to rc/refcell which is often a pain. the fundamental concepts are solid and pretty easy, it's just the awful legacy and implementation details making things difficult.

and of course, rust is great because it's memory safe, with very little run-time overhead (link to absolute memory safety is a myth)

talk about how vale combines the best parts of both of them. also talk about how we can retrofit some of the concepts onto c++, and some of them onto rust (though it needs the LGT for rust, which makes it slower).


# Fuck You, Give Banana (FUGB)

Or: "Fuck You, Give Banana", the insight that helps me maintain sanity while developing software

Scalability is overrated - https://news.ycombinator.com/item?id=34656776

get the thing working

link in our dev velocity article


# Prototype, Launch, Iterate (PLI)

article about prioritizing getting something working vs innovating well

maybe mention that it was a mistake to do templates, and closures. they seemed easy at the time, but they slowed me down a bit when it came to generics. might have been a good idea to rely on some primitive code generation, kind of like C, until the more interesting features were in.

then again, the reverse coulda been true. maybe better to nail down the basics before doing the complex stuff?


Comment by Animats - https://news.ycombinator.com/item?id=34591105

rust: day or two of rewriting to get ownership rihht

- how developer velocity is important for 7drl
- developer velocity is important for hvz. ninjafix


# The Hardest Part of Language Design is Considering Others' Ideas (HPLDCOI)

we tend to identify with what we made. after all, if i made something bad, then i am bad. classic human thinking. we are bright souls on very faulty hardware.

talk about cardinal and his pushing so hard for a rust-like system

talk about everyone pushing back on the let syntax

but its incredibly important. its so easy to fall into the trap of "i know better than anyone else. im the one with almost a decade at google, who knows everything about programming languages."

but even if i know more, i still only know a tiny fraction of what everyone else cumulatively knows.

i can only hope that more people come forward with their proposals.




# When a Language Should Have Templates, Generics, or Both (WLSHTGB)



templates-generics-blend.vmd



# Next Decade in Language Design: Allocators (NDLDA)

next-decade-languages-allocators.vmd



# Vale's First Prototype for Memory Safe Allocators (VFPMSA)


once we have allocators, make an article on how to use allocators to speed up code. show a 100x increase using bump allocation. perhaps for a sort?

use the big-page stack too maybe

show how we can use single-type pools for speedups. A-star?

multi-type pools too

i wonder if we can use a simd hash map for our multi pools




# Next Decade in Language Design: Reference Counting (NDLDRC)

next-decade-languages-rc.vmd




# Next Decade in Language Design: Regions (NDLDR)

next-decade-languages-regions.vmd



# Next Decade in Language Design: Concurrency (NDLDC)

next-decade-languages-concurrency.vmd



# Next Decade in Language Design: Borrowing (NDLDB)

colin gordon

see what verona is doing

pony and recovering

HVM

perceus?

region borrowing. nice because we can freeze some things while the innards remain mutable.


maybe also lament that swift shared its objects across threads, otherwise it would be in an awesome position to take advantage of this.



article overviewing other languages adding borrow checkers
vale and iirc c++, dlang...
also mention automatic, like swift abd lobster
also mention the imm rc thing



# Borrow Checker's Real Purpose (BCRP)

- We don't want a mutable borrow reference at the same time as any other mutable reference.
- Except we _really_ just don't want any borrow reference while it's deallocated.
- Except we _really_ just don't want to _use_ any reference while it's deallocated.
- Except we _really_ just don't want to use any reference after it's been reuse.
- Except we _really_ just don't want to interpret any non-T pointer as a T.

Let's not get fixated on aliasability xor mutability. It's just a useful approximation, a good starting point.





# Decouple Allocation From Logic (DAFL)

Talk about how we like to do this:

- Zig
- C++
- Rust, maybe
- Odin
- Vale

maybe also talk about how it enables our fast compilation stuff



# How Region Borrowing Avoids Overhead (HRBAO)

how-region-borrowing-avoids-overhead.vmd



# Colorless, Colorblind, Fearless, Structured Concurrency (CCFSC)

Basically rehash seamless concurrency, attempt to move away from seamless.

reference zig's colorblind concurrency.

talk about data coloring




article on structured parallelism, explain in terms of rust and C. see discord explanation at start of #structured-parallelism

could this lead to deadlocks? even if we have a DAG? i think so? how do actors avoid this? they send the relevant stack data along. they dont use mutexes. actors are stateless. hmmmmm.
yes, if we lock one mutex then lock another. bollocks.

can a mutex have mutable references to the world outside it?

i think a mutex can have imm access to anything outside it, as long as everything is immutable to the end of its scope. so we can make actors like crazy.

is there a good way to avoid this? could advise to only ever have one mutex locked at a time...

maybe write the whole manifesto first, then decompress it into four or five parts. maybe have an interlude on regular try { } ing?
and perhaps a background article on the region borrow checker on vale.dev.





# Break rules, don't lock mutexes, modify data anyway! (SMLIMR)

(stands for Skip Mutex Lock In Mutable Region)

talk about how if we see a mutex inside a mutable region, we dont need to lock it to modify it. fuuuck thats cool.

rust also has it: https://old.reddit.com/r/rust/comments/150vgyx/whats_the_coolest_function_in_the_rust_language/js5f4qn/

(show an eat trash be free raccoon thing)


# Thoughts on Colorless, Colorblind Concurrency in Rust (TCCCR)

We can _almost_ get there by just assuming data is Sync. However, if we have a reference to something that's Sync, we'd need to use a mutex to modify anything in it.

we trade this problem:

 * dang it, this incoming thing isn't colored such that i can read it from multiple threads.

for this problem:

 * dang it, this incoming thing isn't colored such that i can mutate it.

weirdly vale has that problem, but it doesnt. how did vale avoid that problem?


# When Static Typing Goes Too Far (WSTGTF)

(dont post it this way; static typing is good because it has escape hatches. static *analysis* can be bad.)

Intentionally titled a bit provocatively.

Static typing is good. Polymorphism is good. However, you shouldn't go to the extreme on either of these.

Static typing to the extreme: rust, coq. not much polymorphism, because borrow checking tends to win. could be a cultural thing.

polymorphism to the extreme: dynamic typing.

some problematic examples: async/await. pure.

recommendation: be aware of this. have strong APIs. avoid viral constraints.




# HWSV: How We Simplified Vale

perhaps "How to Simplify a Language"

- Talk about how complexity skyrockets later on.
  - Examples: C#, Rust, C++
- Early on, simplify drastically.
- What I removed from Vale:
  - readonly vs readwrite
  - imm vs mut
  - variability on locals



# Aspect Monomorphization (ASPMON)

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

inko is looking into this too.



# Thoughts on Infectious Systems: Async/Await and Pure (TOIS)


infectious-systems-async-pure-mut.vmd



# Inline Data, using GC, RC, and Gen Refs (IDUGR)

Encourage other languages to do this too

talk about unique types

maybe mention borrowing




# Rust is just the beginning: Advances in speed and memory safety (RIJTB)

basically just a more positive rephrasing of Beyond Rust






# Encouraging People to Try Vale (EPTTV)


## How to do borrow checking in vale

- an article for people coming from rust
- say up-front that vale doesnt use borrow checking, it uses region borrowing, which is designed to be simpler and compose a little better with other features like concurrency, shared mutability, and deterministic runs.
- &mut becomes linear style
- & often becomes pure functions and pure blocks that freeze the entire world
- anyone who needs more precision could use isolates but most of the time using borrow checking to that extent will backfire and end up using more CPU.

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

## How region-based borrowing can enable better structured concurrency

basically a rehashing of seamless structured concurrency

## How region-based borrowing can enable better architecture

Talk about the iso object

## How region-based borrowing can ease the learning curve

Talk about how it blends shared mutability in at the must fundamental level

**"I love the borrow checker, but i don't necessarily agree with how Rust uses it."**

## How region-based borrowing can speed up our code

thisll be tricky, because of the elephant in the room of rust. could be worth it to salesman it.

## Domino 1.0: Elevation, Polygonal Tiling, Symbolic Graphics!

(r/roguelikedev, r/gamedev, r/programming, HN)

- officially released!

## Pentagonal Cellular Automata in Vale

(r/roguelikedev, r/gamedev, r/programming, HN)

- show a vale pentagonal terrain generator
- "we want to grow domino, join us to help out!"

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




# Thoughts on an Easier Rust (TOBR)

(TOBR stands for Thoughts On a Better Rust)


this series would say that vale isn't really there. it kind of does it in some way, but not really. i feel like there's a lot of ways we can go with this, and i want to explore it with everyone.


be very careful to stick to the narrative that this wont necessarily make a language that's _better_ than rust, and these aren't necessarily mistakes for rust. rust prioritizes certain things very heavily. it prioritizes low-level programming over high-level programming, and speed over safety over ease.

could explain what vale does, and ask them to figure out how to make rust do it lol

- immutable calling, the foundation for an easier and simpler borrow checker
- How a region-based borrow checker can ease the learning curve





part 1: raii. talk about linear types, and how they make it possible to detect a whole class of errors at compile time. adjustment 1: decouple onPanic and drop. but alas, we still need shared mutability to have real parameters. tune in for part 2!

part 2: add a base of shared mutability. 
talk about observers, backrefs, graphs, raii.
talk about generational memory.
ackn up front that this can risk some panics. note that we have a lot of panics already, in the form of bounds checking. talk about how these show up in testing. remember testing? it finds bugs, and it works!
and theres options for bounds checking but we'll show how thats mostly equivalent.
ackn up front that this departs from rust tradition, and is taboo.
ackn this likely uses the heap. talk about how thats taboo as well.
perhaps these things can be pinned?

but also talk about how we just introduced a lot of memory overhead. so we're going to introduce a new kind of lifetime, called superimmutable. thats part 3.

part 3: the region borrow checker.

part 4: remove normal shared refs. just have superimmutable and something like refcell but less strict, lifecells.

part 5: add structured concurrency now that we have superimmutable.

part 6: talk about how async/await is infectious. lets switch to a model a little more like loom (copy back into place) and os threads. more copying but it is simpler.

part 7: talk about how &mut is an infectious leaky abstraction like async. perhaps popularize deeply-celled things, like robert talks about. or deeply lifecelled like vale. and refcell. and generational memory. shout out to cone.




## Thoughts on the Next Rust, Part 1: The Actual Strengths

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

## Thoughts on the Next Rust, Part 2: Unique References

You can have them without a borrow checker.

## Thoughts on the Next Rust, Part X: Handles

A handle is basically [vec ptr, id]. This is different than an iterator, which is just a node pointer.

Though, in the case of some data structures that dont move nodes, like linked lists or allocators, they can be the same structure.

We can call .lock() on a handle to get an iterator or a reference. An iterator could be nice because it could lock the underlying data structure and prevent it from changing.

This is nice because it lets us have movable objects, which can be nice.

## Thoughts on the Next Rust, Part 3: Aliasability-xor-Mutability is a Distraction

What we're really after is type stability or shape stability.

Imagine if every primitive and unique reference was mutable, like in a Cell. There's nothing unsafe about that.

The real enemy is aliasability-xor-deletion.

In that light, constraint refs are low key startin to make a lot of sense, dont you think?

## Thoughts on the Next Rust, Part 4: Guarded Borrows

Talk about how accessing an element will lock the element, accessing an array will lock the entire array.

The granularity of locking is a tradeoff.

RefCell

Scope Tether

Isolate

Remember, arrays still have bounds checking.

## Thoughts on the Next Rust, Part 5: Aspect Tracking

Borrow checking is just one extreme, you can track entire regions.

## Thoughts on the Next Rust, Part 6: Copies

To get around the borrow checker, we make a lot of little copies.

It's kind of like how in pony etc we copy between threads.

Funny, compared to pony etc, Rust aint a zero cost abstraction.

## Thoughts on the Next Rust, Part 7: Putting it All Together

Talk about a few theoretical next steps:

- GM + region borrow checker
- HGM
- HGM with outliving
- Cone
- An RC + refcell + borrowchecking hybrid
- RC + region borrow checker





# 150k Lines (L150K)

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
  - everything your write is throwaway code. get used to this early on. what youre really building is the expertise. and then later on, your goal is to make your expertise less important, via docs and testing.
  - keep an eye out for isolated projects: small, medium, large. these will be great for onboarding people.




# What I Told 4,000 Nooglers About Impostor Syndrome (WIT4KN)

(not really related to vale but w/e)

article: what i told 4,000 nooglers about impostor syndrome

article about how my favorite thing about google was teaching the developer workflow classes, i quit google so that i could work on vale and have a much broader reach

then tell them the story about that time at that lunch

tell them how we all have different strengths

the noise in the room is very much from the few geniuses, and people talking about the narrow skill theyve mastered

everyone else is pretending. there are no experts, just people playing the part.

maybe thats okay. its better to have a direction, even if its only semi-informed




# Data and Function Coloring are Bad (DCFCB)

(need better title)

perhaps split out another article on why constraints in general can be bad sometimes. and maybe also that the opposite of constraints is decoupling.

talk about how it blasts through abstractions and basically makes polymorphism impossible


good code is meant to be updated and fixed. if things are nicely encapsulated, you can sometimes fix it in just one spot, because you dont need to worry about constraints elsewhere.

but as soon as you add more constraints, you cause refactoring shockwaves. and refactors cause, you guessed it, more bugs.

when youre choosing a language, you gotta ask: do i want 20% more features to grow your userbase more exponentially, or 20% more speed which translates to 3% more cost? IRL, the answer is almost always features.



an article on why vale can do this kind of structured concurrency reading when rust cant: vale has no escape hatches (it needs none)


talk about constraints.
constraints cause refactoring.
https://news.ycombinator.com/item?id=34591105


when rust keeps us from certain techniques, our code necessarily becomes more complex.

there are very likely situations for which those techniques make for the simplest code. so by necessity outlawing those techniques makes for more complex code. for example, raii and observers.


- being generic over function color causes either code size explosion or brittle breaky APIs
- talk about how it can become even more catastrophic once you go through Option's map function for example
- talk about how it's potentially even a problem in vale's read-only regions
- talk about how we intentionally move the purity checks to runtime
- reference [https://gavinhoward.com/2022/04/i-believe-zig-has-function-colors/](https://gavinhoward.com/2022/04/i-believe-zig-has-function-colors/)
- the alternative (such as vales new threads) are more decoupled. function colors are less decoupled.
- can we tie in composability?


- it's not a problem with rust, just a drawback.
- an important principle of good architecture is that a change should not spread to the codebase around it. this is at odds with some of the workings of rust, for better or worse.
- function coloring
  - & and &mut are infectious
    - parent functions might have to use indices instead of references, which means that my decision over here made that code slower over there. not very zero-cost is it.
  - async is infectious
    - it also has a performance downside. async functions are slower than sync functions. for C# it's 15% https://devblogs.microsoft.com/premier-developer/the-performance-characteristics-of-async-methods/, rust: https://www.reddit.com/r/learnrust/comments/gd133p/why_does_my_async_version_run_slower_than_nonasync/, https://github.com/jkarneges/rust-async-bench. in his words "But if your hand written code wouldn't normally have used Future or something like it, then adopting the whole of async will have a cost"
    - https://discord.com/channels/273534239310479360/616791170340880404/1117134545989410897 conrad ludgate mentions that it sometimes does an O(N) bunch of branching to get to the right place.
- data coloring:
  - lifetimes are infectious
  - sync/send are infectious
- infectious is bad because it can run into interfaces, drop, or public APIs. this can lead to instability.
- i think this is a problem.



article on why function colors are bad

talk about how we cannot be generic over function color

talk about the monomorphizing problem leading to code size explosion

talk about how it can become even more catastrophic once you go through Option's map function for example

talk about how it's potentially even a problem in vale's read-only regions

talk about how we intentionally move the purity checks to runtime




# How Vale Solves Data and Function Coloring (HVSDCFC)

region borrowing for data coloring

weird seamless prototype for function coloring






# One Language Should Never Rule Them All (OLWNRTA)

basically shake people out of the illusion that rust can be the one language

perhaps under the guise that vale will never be either. for example, GC is better for UI.


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




# Why We Should Make More Programming Languages (WWSMMPL)

  - talk about how we're nowhere near the perfect programming language, and the more we try, the closer we'll get.
  - ive seen people of a certain leaning often telling language developers to stop, that we've solved languages, that there's only two paradigms worth using anymore (borrow checking and garbage collection).
  - i kept looking. i found constraint refs, then gen refs, then regions. i discovered perfect replayability that can even call externs in the replay. seamless concurrency. it was difficult, but it showed me how much there's left unexplored.
  - if you're still not convinced, then i'll drop two bombs:
    - a reference counted language with regions.
    - a language like Va that's single threaded and memory safe, and everything's statically declared. memory safety and simplicity. boom. would love to see a zig variant like this.
  - we haven't even scratched the surface, my friends. there is so much more left to discover.
  - if you ever see anyone saying "we shouldnt make more programming languages, show them this article."

after all, vale might fail. i might get hit by a bus.

- See the dogma post
- shape stability!
- regions!
- Safety might be a solved problem soon, with TBI (varying inlines would probably want to be in 16b chunks)
- See elucent's stack-based thing. blend it with RC and actors!
- For example:
  - what if we had a GC'd or RC'd language where pure functions could freeze all existing things? (itd also enable structured concurrency)
  - what if we had an OO language where all transforms were done with FP? (in other words, react)
  - what if we had an actor language with regions, and manual compaction?



# Vale Programming Language's Plans and Ambitions for v0.4 (PAAF4)

talk about region borrow checker, seamless concurrency, inline data

we want a truly unified "selectable" interface and waiter, could be pretty awesome with nanothreads.



# Why Optimizations Shouldn't Affect Logic (WOSAL)





# Why Vale Doesn't Have Enums (WVDHE)

a sealed inline interface is really just an enum. some weirdness happens when its an open interface, but not much tbh.

talk about scala a bit. it really nailed this.



# The Async Design that Took 4 Years to Solve (ADT4YS)

talk about our async/await/goroutine hybrid. our language-aware fibers.

look into "cactus stacks", icefox told us about them



# The Escape Route, and Why Vale Has Semicolons (ERWVHS)

it's because we can always backtrack on it later. a lot of decisions can be put off this way.

this is also why we're intentionally making things as decoupled as possible, especially to start.

(come up with some more examples)

mighe be a silly article since we have epochs


# Notes on Boats' Notes for a Smaller Rust (NBNSR)


smaller-cleaner-language.vmd

https://without.boats/blog/notes-on-a-smaller-rust/

I would also take Rust’s commitment to concurrency-first and make all the available primitives threadsafe. No Rc, no Cell and RefCell. Interior mutability is only allowed through a mutex type, and everything can be moved across threads. Send and Sync would only exist as some built-in checks on ownership-related types.

I think closures and arrays/vecs/slices could also be simplified a great deal by not guaranteeing anything about where they’re allocated, though I haven’t worked out all the details.

Such a language would almost certainly also use green threads, and have a simple CSP/actor model like Go does. There’d be no reason to have “zero cost” futures and async/await like we do in Rust. This would impose a runtime, but that’s fine - we’re not creating a systems language. I already said earlier that we’d probably have garbage collection, after all.




# What Language Designers Should Know About Memory (WLDSKAM)

article on how memory travels from somewhere to somewhere else i dunno

but talk about all the war pigeons that got the Dickin Award


article on post-space-travel architecture

a lot of push stuff

unlimited bandwidth, but latency is the real trick

maybe work in CRDTs?




# How to Use Tech Debt Wisely (HUTDW)

Make sure you're doing it for the right reasons. the question is: what are you buying with this tech debt?

 * Fuck you give banana
 * funding
 * notoriety, fame, renown
 * congratulations
 * a sanity check on where the project is heading

1:2 to 1:5, talking about how valuable it is to do various things when working on a project. saving yourself two hours later on helps you a little bit, but getting your stuff earlier is 1:5.

your time now is _extremely_ valuable. much more valuable than it will be 5 years from now. optimize for growth right now, because then, someone else can do that thing.


TAKE NOTES for god sake. dont leave it to the reviewer to catch opportunities, because it's impossible!


do alternating sprinting/cleanup.

 * we often just blast away parts of the prototype. hacks put in place. its okay as long as all of them are known.
 * this helps because getting far gets us a much better picture of what we'll actually need from the surrounding infrastructure. this is why it's so important for a language to be refactorable, and why i chose scala for the frontend instead of something like c, c++, or rust. (lol)


Always pay it down. The first time you don't, you are no longer allowed to follow this approach. (You are doing something else, and you need to come up with a different name.)


i dont know if vale will be here two years from now. we might not have the sponsors for that. so its good to just take note of those long term things and solve it when we get there. otherwise we fizzle out and do zero good. its better to prove the concepts exist, for the next language to take over.



# Difference Between Software Engineering and Artistry (DSEAA)

Or perhaps: Software Engineering is Not Artistry

talk about how there are two kinds of programmers:

 * software engineering is about getting things done in pursuit of a goal.
 * artistry is pursuing other goals, usually elegance.

its good to let a little bit of artistry in when it serves the ultimate purpose.

we often think we're pursuing one goal, when we're really just pursuing artistry.

code often just pleases us, but not for any particular purpose. it tickles our fancy in a way that we've trained ourselves to like.

i used to like the DAG hierarchies of OO. i used to like borrow checking. but all of these are just noise. stop chasing the high, and make something useful!


# Why Linear Types (WLT)

See why-linear-types.vmd




# Single Ownership Without Borrow Checking (SOWBC)

talk about higher raii, linear types, all that good stuff

- talk about how this is what c++ does

- perhaps also mention lumi

- it lets us do a lot of new things like better raii, observers, backrefs, graphs, dependency refs





# EC vs ECS in Roguelikes (ECECSR)

maybe its time for the EC vs ECS article. somewhere in there, mention that rust very much forces you into ECS because you want to read from the world, modify property X, read property Y.


# The Good Parts and Bad Parts of OOP (OOGPBP)

Article: "The good and bad parts of OO, and what new languages should take from them"

(re borrow checker is bad, perhaps not the place for it:

 * luckily, you can always reshape your architecture to accommodate. though, pushing complexity upwards is the sign that somewhere, your abstractions are leaking. at least its not your fault here, it comes from the borrow checker itself. and rearchitecting gets more and more difficult as time goes on, so you really need to be aware of these drawbacks early on.
 * hidden cost: Interchangeability.  Show a button. itll either use a fake network requester or a real one. but uh oh, when it comes time to add the real one, we need to change the interface to hand in a real network manager! but we dont have one! now we cant hold onto our request, aww. that would have been nice, so it could automatically be canceled when we go out of scope. now we're vulnerable to that kind of data inconsistency bug.


good: modularity, encapsulation, polymorphism
bad: inheritance

avoid infectious things that blast through those. like async and &mut.


how one can get the benefits of OO without the drawbacks if they just stop using the "extends" keyword


- flexible code is important. we knew that the PM would be asking for more. (from kim in chat with the ... see more link)
- its important to make loose code. crystal balling can help you know where more looseness might be beneficial. (kim again)
- in 7drl, good enough is the goal.



often, a collection is just single owned ptrs and it works nice. good balance between borrow checking and GC.


article: "Lessons learned from Rust and Object-Oriented Programming"

talk about how OOP is mostly bad but has some great strengths, specifically in solid APIs that are resilient to changes. when youre in the field, you want a good lieutenant. you just want to issue commands. if the situation changes, you dont want him to bring you ever little detail, you dont want to know the concerns of his day to day operations. you just want to tell him to do the thing, and he'll find a way to do it. thats a solid API. it lets you focus on the more important things (business logic).

rust is good because it solves a lot of oop's pain points. bubble up top down.

of course, we can do both of these, they arent incompatible. talk about the google earth architecture perhaps.



in fact, i used this pattern to great effect when i wrote the webapp for one of google's internal events, a 400-person nerf war. (back when google was cool)

we had an in-memory database, and an actual firebase-backed server. by adding an extremely simple version, we could get features up and running in the UI in parallel with the backend folks.

this is what it means to be an architect: using the right decoupling in tbe right places.

a lot of people attempt to do this in rust, run into the borrow checker, and back off. however, we can get the right interchangeability if we use the right combination of workarounds and trait objects.

(link to the borrow checker article)

functional programming has a difficult time woth this, for the same reason.

the unfortunate reality is that we see less interchangeability and abstraction in these languages, then we do in ones that use dhared mutability.

but luckily, there is hope. OO concepts are coming back into the world via higher 

the benefit is that you can abstract away components and make them interchangeable.




# The Fastest User Study of All Time (FUSAT)

talk about the right click, and how we had no idea what he did until way later. if we had recorded it, we would have known lol

it happened again: my gf played incendian falls and instantly went up the staircase that i implied you just went down.

my brother played it, and then crashed it. he didnt know what he did though. luckily, perfect replayability did!


then a youtuber played it and tried the same thing. good thing i did a user study!


# Vale's Perfect Replayability Stabilized (VPRS)

(once we really nail the whole universal references thing and have no bugs and stuff, and FFI is done)

string's GetHashCode() is nondeterministic in C#

rr will let you debug just one execution. pretty nice, but lets go further.

we can let you add any vale code you want, as long as it doesnt read anything from FFI. you can completely refactor your entire program.

well, you can completely refactor anything that doesnt involve adding threads, probably.



# Using the Stack with Generational References (USGR)

talk about how random generational referencs and the LGT make it so we can do this.




# Flexible Perfect Replayability Prototyped (FPRP)

How does replayability work when ASLR is a thing?

It's because it's not observable to the code's semantics.

Same with generations.

Java could almost do it, but they let some nondeterminism creep in (weak references, some other things).

Rust can almost do it, except for their unsafe blocks. we'll never have determinism in rust, unfortunately.

However, there's an interesting way we can bend the rules. Here's how opaque types work!




# Evan's Rules For Evangelizing Languages (ERFEL)

- you found a language youre happy with, and you want to share that happiness with others. that's awesome! this page should help you with some do's and dont's.
- rule of thumb: if they weren't already talking about vale, or programming language comparisons, lean towards not bringing it up.
- "what if i want to tell people how great vale is?"
  people rarely care about new tools. it happens, but most people just find it irksome.
  there are certain situations where they probably do care.
  - if they ask if there are better tools for something, you can suggest vale.
  there are also some settings.
  - r/programminglanguages is a great place.
- "when should i suggest someone rewrite something in vale?"
  - this is almost *never* a good idea, for any language. times when its a good idea: ... . but also, read the room.
- "so then how can i spread the word about vale?"
  start from rule #1
- if you are truly trying to solve their problem, then make some other suggestions besides rewriting in vale.
- if it's something that *only* vale solves, and people didn't know languages could solve that, feel free to mention it, but without agenda. examples: vale solves race condition repro'ing




# How Demonic Names Help Large Programs (HDNHLP)

- article on the shortlinks. use RMLRMO as an example, because that was confusing. it was a shortlink that saved us time there.

talk about the various shortnames like DMPOGN GLIOGN and how i was talking to myself and gf said "it sounds like you're summoning demons over there."
let's talk about demons!



# Static Typing and Super-Static Typing (STSST)

names are important. i want a name for these.

talk about:

 * type-state programming
 * going past stringly typed

maybe also mention these, though they aren't really the same:

 * higher raii
 * lifetimes
 * regions



# A List of Single Ownership Languages (LSOL)

mention c++ first perhaps? or maybe put it in another category? maybe anything that has a different owning vs non owning ref



# Why Rust Should Have Linear Types (WRSHLT)





# Religiosity in Programming Languages (RIPL)

talk about it from the angle of, every language does this. i sometimes feel tempted to do this. this is a reminder mostly to myself.

languages have a heavy survivorship bias and selection effect: they pushes away those who care about this kind of thing, and leaves only the people who think it's not a problem, or even a good thing.

talk about sour grapes, and its converse. does it have a name? "false acquired taste" perhaps?

The cycle of programming language religiosity, from OO to FP to Borrow Checking
  - [https://discord.com/channels/@me/609631444003717135/972332091859664907](https://discord.com/channels/@me/609631444003717135/972332091859664907)



# Composing Borrowing and Mutable Aliasing (CBMA)

https://www.reddit.com/r/ProgrammingLanguages/comments/stg4ya/comment/hxlbgcl/?utm_source=reddit&amp;utm_medium=web2x&amp;context=3

talk about what i mean by this.

show a really simple example, with some sort of interconnected thing. the biggest challenge will be finding an interconnected thing that people really want, but can't be done in rust.

maybe dont put this on the rust subreddit. or maybe do it one day if feeling healthy and we're in a good position to defend our walls.




# Thoughts on Language Complexity (TOLC)

See thoughts-language-complexity.vmd




# A List of Fast, Memory-Safe Languages (LFMSL)

memory safe and still fast. maybe praise rust a little bit to get aligned with the readers' values. talk about HVM, ante, lobster, vale.


or "Safety and Speed without Borrow Checking"

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




# An Easy Way for a Language to Add Custom Operators (EWLACO)

Talk about how it was really easy, just do alternating, and a set precedence.

semicolons might be nice here.



# How to Not Need Default Values Or Null (HNNDVN)

need a better title.

c++ needs default constructors for arrays

C# structs need zero constructors wtf why

All golang things have zero constructors, BS

Even rust struggles: [https://www.joshmcguigan.com/blog/array-initialization-rust/](https://www.joshmcguigan.com/blog/array-initialization-rust/)

Scala really shines here

vale's weird array thing is kind of like a vector.

you can also just take in a lambda.




# Try, Catch, Mutexes, and Channels in Vale (RAEH)

(RAEH stands for resilience and error handling)

Talk about how we'll use regions, mutexes, channels, etc. as the foundation for our error handling.



# A Possible Approach for Software Transactional Memory (APASTM)

talk about regions and a possible `txn` region.

look into verse?


# How to Avoid Mutex Poisoning (HTAMP)

basically a rehash of APASTM



# Destructor Parameters in Rust, Austral, C++, and Vale (DPRACV)

talk about how c++ usually has members for it

austral is like a fixed rust

rust needs to escape the borrow checker

vale can do it just fine



# How to Write a Really Slow Compiler (HWRSC)

tell about the surprisingly slow parts of our compiler, and what we did to speed it up.

mention hashing lol

mention .filter, .exist

mention the tech debt, and how we're paying that off now.



# 'This' Parameter Is Not Special (TPINS)

look in all args' envs

we have overloading in rust. lol




# Why Undefined Behavior Isn't Necessarily Bad for Languages (UBINBL)

purpose of this is for other language designers out there. dont limit yourself to just what's defined behavior. if i did that, we wouldnt have random generational references, which i think are really cool.

https://discord.com/channels/398263331808346123/884913138271658004/884918358489841744

talking about how we cant do something because its UB. but its just an LLVM problem really. if we move off LLVM, suddenly its not UB!

but also talk about the cost of consistency across CPUs. some CPUs need extra instructions to wrap properly.

could talk about this in context of generational references: accessing released memory is UB in C, but totally defined in vale.




# Why Vale Doesn't Have a Borrow Checker (WVDHBC)

perhaps better title "Should Vale add a Rust-style borrow checker?"

- talk about the borrow checker's costs:
  - polymorphism sucks
  - its difficult, against the gradual complexity ideal
  - it does have runtime costs, in bounds checks. makes me wonder, is there something better out there?
    - hence exploring HGM
    - hence exploring TSM




# The Hardest Part of Designing a Language is Moving Past the Dogma (HPDLMPD)

dogma.vmd




# WTF, Vale's Pure Functions Can Access Globals (PFCAG)

it's because they only purify/immutabilify the pre-existing memory, and kinda like, the big exception is channels and mutexes, and all globals are channels and mutexes, so it just kind of happened man.



# Rust and C++ Ideals Above Low-Level Programming (RCIALLP)

(r/programminglanguages, r/programming, r/rust, HN)

avoid the term "systems programming", it unnecessarily glorifies.

mainly talk about how we want to use rust above low level programming, what languages do it well, and what the roadblocks are.

talk about verona, pony, and vale, and how their regions can bring rust's ideals upward.

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



# Why Vale Doesn't Have Unsafe Blocks (WVDHUB)

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



# When to Eliminate Gen Checks (WTEGC)

when-to-eliminate-gen-checks.vmd


# Why Have Panics (WHP)

why-have-panics.vmd


# Why Regions Over Borrow Checking (WROBC)

why-regions-over-borrow-checking.vmd





# Perfect Language for Roguelike Games (WWPLRG)

roguelikes-language.vmd



# Vale's First Immutable Borrowing Example, Explained Step by Step (FIBEE)

zero-check-program.vmd




# Thoughts on the Inevitability of Function Coloring (TIFC)


talk about the ISender<T> thing i talked about with icefox



# The Paths Beyond the End of Memory Safety (PBEMS)

need a better title, this one is so arcane, and annoyingly confrontational


we all think that we've reached the end of memory safety, that its basically between GC and borrow checking. a tradeoff of simplicity and speed.

what everyone doesnt know is that the borrow checker is one specific spot on a very large spectrum. rust is charging blindly in one direction, with its lantern, not realizing that there is more than just its 20ft of light. rust is in a massive cavern.

and little do we know, some others have also looked through holes and not realized a massive cavern lies beyond.

im about to blow your minds and illuminate the entire cavern.

lobster: RC and static analysis
val: mut and clone
hvm: borrowing and cloning
basil: arenas and cloning
odin and zig: rust programs often end up like... (explain Va)
odin and zig: arenas (link to rfleury)
cone homogenous regions
vale: regions
forty2: regions
pony: iso

the five things the borrow checker pushes us toward:
- cloning. hvm, val, basil
- borrowing. hvm, vale takes it further by putting it on top of mutable aliasing
- thread isolation. lobster, cone, vale takes it further by applying it to the FFI boundary too?
- isolates. forty2, pony, vale takes it further by parameterizing isos
- unique refs (val, c#s struct)
and also kind of arrays for memory safety (cone homogenous regions, zig, odin)

but we can mix and match them, and get the best of all worlds. rust takes isolates a little too far, resulting in the axm restriction, which is the principle downside of rust. but we dont need to go that far. better tradeoffs exist out there. OO gave us interfaces. FP gave us expressions. what does rust give us that we can take with us to new fields?

lets not get stuck in a specific way of thinking. there is so much more, if we just look up.

when we look up, we find that theres a vast field of potential, of new ways of thinking, ways to do better than what we have today.

just as structured programming lifted us up out of assembly forever, i think this new understanding will lift our eyes and show us the next steps in programming language design.



# Languages need to solve the right problems (STRP)

It's easy for us in our little bubble to forget the people who actually use our languages. Ash is making games. Jen is making a note-taking app. James is making a forms-based web app.

But when we talk about languages, we don't talk about things that will really help them make those things. We talk about things like zero-cost abstractions and mutability which are so far removed from what actually matters.

What's the easiest way to get to an app that meets all of Ash's requirements? C#. What's the easiest way for Jen to make her note-taking app? Kotlin or Flutter. What's the easiest way for James to make his web server? Go. Hands down.

Things like higher-kinded types and permissions and borrow checking and immutability are fascinating to us, in our little bubble. But to Ash, James, and Jen, they are weird obscure mathy things that dont help them make their thing. They get in the way. And they're right!

The problem is that we get so distracted in the irrelevant elegances of programming art that we lose sight of what's actually important: help the user achieve their goal as efficiently as we can. Give them the tools to succeed, and stay out of their way, because they are trying to accomplish a specific goal, not trying to create some sort of software perfection.

This is the starting point. We _cannot_ lose sight of this. As we add features to languages, we need to be careful to keep things easy, add our tools, and stay out of their way.

We are approaching this the wrong way. We need languages that make it easier to make things. Languages need to fit the user's situation and work _with_ them, not against them. Nobody wants to use a HammerPlus2000 that only works on Tuesdays and only if they hold it the right way. They want a simple, reliable hammer. And bonus points if it has a claw too, if it stays out of your way when youre hammering.

If you want to learn more about the specifics of this philosophy, check out:

- ignorable complexity
- avoiding forced complexity
- something

if you want to hear how this applies to vale, click here (talk about single ownership is really for higher raii plus speed, and its opt out just use the heap)


# Where Should Vale Go (WSVG)


article "Where we plan to go after finalizing Vale's memory management strategy"

talk about how its kind of an open question.


we could get really good at serverless, no startup times and seamless concurrency could be insanely cool. CLI apps could really benefit from that too.

games would love vale's single ownership without borrowing.

webassembly could be a good target, since we could do observers really well.

should we dive into embedded programming? vales unique unsafe could be a boon. but, the extra 8b per object could suck. then again, people use python for embedded programming. also, we need segmentation faults, which could be a hindrance. unsafe mode could be good perhaps.

want to hear from those listening!

(might be surprised at responses)



# How Languages Affect a Program's Architecture (HLAPA)


article on how PLs affect architecture
- rust encourages top down. no observers. no reactive.
- fp probably does too
- java encourages complexity and brittleness
- python and js encourage nothing
- dart ?
- actors like pony?

hoping vale will:
- DAGs like phoenix
- leaf pure functions
- lots of structured concurrency

in any article mention the progress made in the past year, what we're working on now, and our larger current goal

- the kind of architectures rust's borrow checker influences you into, its benefits, its weaknesses, and how the region borrow checker might compare
- how abstraction helps architecture (via decoupling) and the kinds of abstraction that different languages offer



# Should Checks Be At Compile Time (SCBACT)

article: most checks should be moved to compile time... but not all

article on when a check should be compile time or run time.

talk about leaky abstractions, ones that blast through or slam into APIs and interfaces. talk about how it can cause massive pain for changes  and therefore becomes an architecture concern

talk about the difference with type systems, and how you can often just add a typeclass or a wrapper object

article: thoughts on detecting every error at compile time.

we say we want this, but we really don't. it's a huge case of cognitive dissonance.

we dont want to account for every error at compile time. imagine if we had a Result for every addition, so that we could handle overflow at compile time. ridiculous, lol. imagine if in rust, on every dereference, we would need to check for a ram error. after all, they do happen in the normal course of events. it's better for ECC to detect it and trap, and just bring down the process. no, that's ridiculous. we'd have Result everywhere.

we can't pretend that it's life-or-death to have an unexpected error. the power could go out at any time. it's just a reality, and we're used to it.

the only natural course is to then have some sort of automatic propagation upward. behold, implied panics.

mention:
- safety critical software does want to be more careful
- detecting every non-owning dereference is a gray area. vale and cheri say implied, rust says explicit.


write an article on assertions

have a section on  should i use type state programming or the type system for all guarantees? say no, because they tend to fall apart in the presence of encapsulation and decoupled concerns


# Abstractions Can Be Good (ACBG)

article: hot take: abstraction can be a good thing

http

linux, posix APIs

> The purpose of abstraction is not to be vague, but to create a new semantic level in which one can be absolutely precise. (Djikstra)

article about good abstractions

firebase is one

react


# Code Size in Language Design (CSILD)

article: "Compression in Language Design: C#, Vale, Swift, Rust, Java, and C++"

talk about type erasure, jvm bytecode being compact, c++ and rust being template heavy. c#s interesting compromise.

then talk about the challenge with making regions work well. minimizing information in templatas helping mitigate the explosion. type erasure making for better compilation times



monomorphizing huge code size
https://news.ycombinator.com/item?id=28818536
possibly big weakness in rust and c++

article on selective monomorphizing, when compiler has the choice
can use pgo too

article: WebAssembly, Binary Sizes, and Compile-time Polymorphism

talk about how we might not want to monomorphize everything. talk about branch prediction

talk about this is why jvm and clr are so brilliant

talk about how we can whitelist certain parts

itll need a language that is high level enough though, that can be polymorphic over type erasure.




# How Vale is Like a Database (HVLDB)

article: "Your language should be a database"

talk about fearless FFI recording all inputs and outputs

talk about WAL (write ahead logs)

talk about transactionality



# Vale's First Prototype for Memory-Safe Unsafe (VFPMSU)

Does a systems programming language really need unsafe?


# Lessons from Rust for Newer Higher-Level Languages (LRNHLL)

An article on how we still have shared mutability of a sort, and we dont know it but we \_really\_ want the compiler to more precisely support us in that endeavor.

celebrate all these great things the borrow checker showed us

inspire them, show them how rust is lighting the way, putting its mark on CS, and making every language better

...and then proceed to highlight good and bad of the borrow checker

- AXM: great on a per-region basis, i think
- we can track non-type things in the type system! this is big!
  - could even track "untrusted" user input maybe?

"With that in mind, I see this article as not understanding the goals and tradeoffs of Rust. The author would be happier writing in a higher-level language than Rust."
lol
https://news.ycombinator.com/item?id=29208196


## Rust Should Add Super-Immutable

So that it can really do fearless structured concurrency, like Vale.

Should be a ghost-written article perhaps.

if we could just assume things were Send/Sync, then we'd be able to do this in rust. unfortunately, rust currently assumes everything isn't sync/send.








