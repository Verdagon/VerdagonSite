# Mojo's Dependent Types: Computing With Types, Not Just On Types

Most languages let you parameterize types with other types (`List[Int]`) or constants (`Array[Int, 10]`). Mojo goes further: types can contain *arithmetic* on compile-time values. When you write `SIMD[dtype, 2 * size]`, that multiplication happens in the type signature itself.

This isn't just syntactic sugar. It's a different way of thinking about types.

## The Power of Type-Level Algebra

Consider concatenating two SIMD vectors:

```mojo
fn join(self, other: Self) -> SIMD[dtype, 2 * size]:
    # Concatenate two vectors
```

The return type isn't just parameterized—it's *computed*. Join two 8-wide vectors, get a 16-wide vector. The compiler calculates `2 * 8 = 16` and verifies the dimensions. No runtime checks needed.

This extends to complex calculations. Matrix multiplication? `Matrix[M,N] * Matrix[N,P] -> Matrix[M,P]` with compile-time dimension checking. Convolution layers compute output shapes: `HO = (H + pad - kernel) // stride + 1` right in the type. Buffer allocation becomes exact: `InlineArray[T, width * height * channels]` allocates precisely what you need.

The compiler does the math so you don't have to—and catches dimension mismatches before runtime.

## How The Parameter System Makes It General

Here's the key insight: Mojo's compile-time and runtime code use the **same language**. Not a separate template metaprogramming system—the same grammar, same types, same operators.

At compile-time, `Int` is `Int`. The `+` operator works the same way. Function calls work the same way. Write `2 * size` in a parameter expression, and it's just multiplication—the same multiplication you'd use at runtime.

```mojo
fn process[size: Int](vec: SIMD[dtype, size]):
    @parameter
    for i in range(size):  # Same 'for' syntax, evaluated at compile-time
        # Same operators, same function calls, same language
```

This makes dependent types **generally applicable**—not limited to special cases or specific types. Any operation that works at runtime automatically works in type expressions. No separate template language to learn. No special-cased arithmetic.

Compare to C++ where template metaprogramming requires completely different syntax and patterns. Mojo's approach: same language, different evaluation time.

## Why x*2 and 2*x Are The Same Type

Here's where it gets interesting. Without special handling, `SIMD[dtype, 2*size]` and `SIMD[dtype, size*2]` would be *different types* requiring manual conversion. That would make dependent types unusable.

Mojo solves this with two mechanisms:

**First**, `@always_inline("builtin")` on arithmetic operators makes them transparent to the compiler. Instead of `2*size` becoming an opaque function call `Int.__mul__(2, size)`, it becomes a symbolic operation the compiler can manipulate.

**Second**, the compiler automatically canonicalizes parameter expressions. Both `2*size` and `size*2` reach the same canonical form (constants sorted right, variables left). After canonicalization, they're literally the same object in memory. Type equivalence uses pointer equality: same canonical form = same pointer = identical types.

This exemplifies Mojo's "high-level operations" philosophy: parameter expressions stay as symbolic operations (`POC::Mul`, `POC::Add`) rather than being immediately lowered. Keeping them high-level lets the compiler reason about equivalence, simplify expressions, and produce better error messages.

Result: write arithmetic however feels natural. The compiler recognizes `SIMD[dtype, 2*size]` and `SIMD[dtype, size*2]` as the same type automatically.

## The No-Constraint-Solver Philosophy

Most dependent type systems require constraint solvers, making compilation slow and unpredictable. Mojo takes a different approach: simple canonicalization rules plus compile-time evaluation. No halting problem, no constraint solving, no compilation time explosion.

When the compiler can't prove equivalence symbolically, it evaluates concrete values. When it can't do that, you use `rebind` to assert equivalence. This happens rarely in practice because canonicalization handles most cases.

The system is predictable: you know what the compiler will optimize and what it won't.

## Compile-Time Regex: 16x Faster

Here's the payoff. We built a compile-time regex matcher using dependent types. The pattern parses at compile-time into an AST. The node structure embeds counts in types: `RegexOrNode` has `num_options: Int` as a type parameter.

Matching functions take the entire regex as a compile-time parameter:

```mojo
fn _match_node[regex: Regex, node_idx: Int](text: String, start_pos: Int):
    alias node = regex.nodes[node_idx]

    @parameter
    if node.isa[RegexOrNode]():
        alias or_node = node[RegexOrNode]
        # Unroll loop over options at compile-time
        @parameter
        for i in range(or_node.num_options):
            var result = _match_node[regex, or_node.options[i]](text, start_pos)
            if result.matched:
                return result
```

The `@parameter for` loop unrolls completely. The compiler generates specialized matching code for your specific regex pattern. No interpretation overhead. No runtime dispatch. Just direct, compiled code.

**Result: 16.4x speedup** over runtime compilation (13.5μs vs 223μs) matching email patterns. Comparable to C++ CTRE but with cleaner, more maintainable code.

The dependent types make this possible. State machine transitions use types like `State[count+1]`, and thanks to canonicalization, it all just works. No manual type conversions needed.

## What This Means

Dependent types in Mojo aren't a research feature—they're a practical tool:

- Matrix dimensions checked at compile-time
- Buffer sizes calculated automatically
- Zero-cost abstractions with readable code
- Domain-specific languages compiled to optimal native code

And because there's no constraint solver, compilation stays fast and predictable. The compiler does math in types, simplifies it automatically, and generates exactly the code you need.

That's dependent types done right: powerful enough to matter, simple enough to use.

---

*Want to see the full compile-time regex implementation? Check out the code in this directory.*

# notes/questions (for reference)

## question 1

my Q was:

so is it general because we use the same language at runtime and compile time? yet always-inline-builtin lets the compiler eagerly lower that to something more usable for the dependent types system, something that can be canonicalized and often folded (eagerly evaluated). is that kind of whats going on or have we been talking about something else?

cursor answer:

Yes, exactly! You've got it. Let me clarify the relationship:

### The Two-Part System

#### 1. **"General" = Same Language, Same Types**

This is what Chris meant by making it "general":

- You write `2 * size` using the normal `*` operator
- `Int` at compile-time is the same `Int` type as runtime
- Same grammar, same function calls, same everything
- **This makes dependent types broadly applicable** - any operation works automatically

#### 2. **@always_inline("builtin") = Making It Practical**

But without the builtin inlining, the "same language" approach would fail! Here's why:

```mojo
// Without @always_inline("builtin"):
2 * size  →  Int.__mul__(2, size)  // Opaque function call
// Compiler can't reason about it, can't prove equivalence, can't simplify
```

So `@always_inline("builtin")` makes it work by:

- **Eagerly inlining** the function body at parse time
- **Lifting it to symbolic form**: `Int.__mul__(2, size)` → `POC::Mul(2, size)`
- Now it's in a form that can be:
  - **Canonicalized** (sorted, simplified)
  - **Folded** (eagerly evaluated when concrete values are known)
  - **Compared** (via pointer equality after canonicalization)

### The "High-Level" Twist

The key insight: this is actually keeping it **high-level**, not lowering!

- Traditional lowering: `2*size` → machine instructions
- Mojo's approach: `2*size` → `POC::Mul(2, size)` → stays symbolic
- This high-level representation lets the compiler reason, simplify, and compare

So you're right: it's **general** because same language everywhere, and **@always_inline("builtin")** makes that generality actually work by eagerly transforming operations into a canonical form that can be manipulated. The "high-level operations" philosophy is about keeping those operations as symbolic `POC::` ops rather than immediately lowering them to implementation details.

Perfect synthesis!

## question 2

im having some doubts about whether this is compile time regex stuff is really compile-time dependent types. i think it is, but i forgot whether/how. supposedly, being able to call functions on compile-time data is what classifies something as dependent types.

but ive also only really thought about dependent types as having operations inside the compile-time-parameter list, such as the `*` in `SIMD[Int, N * 2]`. and its not super clear that thats happening in the compile time regex example. is my definition there too strict, or what should i think about this like?

but these regex nodes are computed based on compile-time data supplied by the user, does that factor into the distinction?

Answer:

Ah, NOW you're hitting on something important! Let me reconsider...

Yes, this DOES factor in, and I think I was being too narrow. Let me show you why this IS actually dependent types:

### The Key Insight

When you write:

```mojo
alias email_regex = Regex("\\w+@\\w+\\.\\w+")
fn matches[regex: Regex](text: String) -> Bool
```

The **function's type depends on the regex value**!

Functions specialized on different patterns are actually **different types**:

- `matches[Regex("a+")]` is a different function than
- `matches[Regex("b+")]`

The function type **depends on the value** of the regex parameter.

### Two Flavors of Dependent Types

**Narrow definition** (what you were thinking of):

- Arithmetic in type signatures: `SIMD[dtype, N * 2]`
- The array type itself contains computed values

**Broader definition** (what regex shows):

- Function types depend on values: `fn matches[regex: Regex]`
- Different parameter values → different function types
- The function is specialized based on compile-time data

Both are dependent types! One has computation **in the type**, the other has computation **determining which type**.

### Why It Counts

The regex pattern (user-supplied compile-time data) determines:

1. The AST structure (computed at compile-time)
2. Which specialized function gets generated
3. How loops unroll (`range(or_node.num_options)` - depends on parsed data!)

So the type of the generated matching function **depends on** the computed AST, which **depends on** the user's string.

Chain: `User string → Parse → AST → Function specialization → Different types`

### The Real Distinction

Actually, both examples use the same principle:

**SIMD arithmetic**: `SIMD[dtype, 2 * size]`

- Type signature contains arithmetic on parameter

**Regex**: `fn matches[regex: Regex(...)]`

- Function type determined by parameter value
- Code generation depends on structure of that value

The regex just has **more complex computation** (parsing) between the user input and the type-level effect.

### For Your Article

You could say:

> "The dependent types make this possible. The function type itself depends on the regex pattern—different patterns produce different specialized functions. The `@parameter for` loops unroll to exactly the number of alternatives in your pattern, computed at compile-time from the parse. Thanks to canonicalization and the same parameter infrastructure that enables `SIMD[dtype, 2*size]`, it all just works."

So yes, it IS dependent types, just a different application of the concept! Your intuition to question it was good, but the answer is: it's dependent types at the function level rather than just at the type-expression level.
