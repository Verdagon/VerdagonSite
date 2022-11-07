
# Similarities

(from part 5)

This will sound familiar to those who have used Java and C#: When iterating over a collection, we aren't allowed to add or remove nodes, [# See [MoveNext](https://learn.microsoft.com/en-us/dotnet/api/system.collections.ienumerator.movenext?view=net-6.0)] but we're free to modify the nodes themselves. Here, we're doing the same thing, but harnessing that restriction for extra speed.


This will also sound familiar to those who have used Rust:

 * If one has a reference to an immutable region's List<T> in Vale, then accessing its contents is zero cost, similar to if we have a `&Vec<T>` in Rust.
 * If one has a regular reference to a `List<T>` in Vale, then under the hood it opens the cell immutably, similar to Rust's `RefCell::borrow`.

Vale takes a flexible approach and does the most efficient thing depending on the circumstance.


Vale's real strength here is that the user doesn't have to know about regions, and can still benefit from them when libraries use them under the hood, like the collections in the standard library. This helps Vale be fast and safe while still remaining simple.


If the user wants to squeeze that last ounce of performance out of their program, they can gradually add regions to the places where profiling says they could benefit from optimization.


# Generics and One-Way Isolation

Collections like LinkedList use one-way isolation.

[# Draft TODO: could we say `struct LinkedList<T> cell {`? could be good sugar.]

```
struct LinkedList<T> {
  head ''?LinkedListNode<T>;
}
interface LinkedListNode<T> {
  value T;
  next ?LinkedListNode<T>;
}
```

T is a reftype, which contains the region, ownership, and kind.

We can hand it something of a different region:

LinkedListNode<&outer'Spaceship>


This is extremely useful, because it means we can iterate over the list with zero cost.

```
func foreach<T, F>(list LinkedListNode<T>, func F)
where func(&F, &T)void {
  head = list.maybe_head.open;
  maybe_current = head;
  while current = maybe_current {
    func(current);
    set maybe_current = current.next;
  }
}
```

Anything with generics is implicitly using one-way isolation.







# A Simple Example

Here's an example where a cannon is firing upon a ship.


<<<<
In the `'Cannon(9)` call, the `'` makes the resulting Cannon into an isolate.


The `attack` function:

 * Receives the cannon in a read-only region `c'`.
 * Reads `cannon.power`, with no generation check needed.
 * Subtracts from the ship's health.

////
```
struct Cannon { power int; }
struct Spaceship { health int; }

exported func main() {
  cannon = 'Cannon(9);
  ship = Spaceship(22);

  attack(cannon.read, &ship);

  println(ship_b.health);
}

func attack<c'>(
  cannon &c'Ship,
  ship &Ship)
void {
  set ship.health =
    ship.health - cannon.power;
}
```
>>>>

In this example, reading `cannon.power` was zero cost, because we used `.read` to open the iso immutably.


This is the true strength of isolates: they tell the compiler when areas of our data are immutable, so it can read them with zero cost.







# Swapping


In this example, a `Ship` has a private `Engine` that nobody outside needs to access. We'd also like to make it faster to read this engine, so this is a perfect use case for an isolate.


<<<<
When we want to access it, we swap a None into its place, and then put the isolate into a local.


When we're done, we put the isolate back into the `Ship`.
////
```
struct Ship {
  engine! Option<'Engine>; «question»
}
exported func foo(ship &Ship) {
  engine_iso =
      (set ship.engine = None())
      .expect();
  engine = engine_iso.read;

  // Can read engine freely!

  set ship.engine = Some(engine_iso);
}
```
>>>>


Luckily, we have some syntactic sugar to deal with this for us, called *cells*.


<slice>
#question: This would normally be written `engine! ?'Engine', since `?` is shorthand for `Option`.
</slice>



# Cell stuff



Cells have an extra hidden benefit: if the containing `ship` is immutable (such as if `foo` was pure) then it would skip all the above and just read it directly. [# It does this with a certain feature called "region overloading", which specifies one function to use for immutable regions, and another for readwrite regions.] [# Design TBD: We might actually want to add an assertion even when in immutable regions too, that someone else doesn't already have it opened. It wouldnt cause any unsafety if we don't, but it might be good to be consistent. At least in debug mode, perhaps.]


There is one danger to be aware of with all of this: one cannot `.open` and `.read` a cell at the same time. If they do, the program halts. [# This is similar to the behavior of Rust's RefCell.] [# Draft TODO: `.open` for writing, `.imm` to force it immutable. Perhaps we can also have a `.read` that would never fail; it would do regular GM but cannot modify anything, probably pretty common to use it for quick immediate reads. In fact, static analysis could probably eliminate a lot of the overhead there.] [# Draft TODO: Perhaps even more sugar would help: `struct Ship ''{ engine Engine; }` to wrap all the contents in a cell.]



This is actually just syntactic sugar for some machinery in the standard library:

 * `''Thing` is sugar for `Cell<'Thing>`
 * `engine = ship.engine.read;` becomes two lines:
    * `engine_guard = ship.engine.open();`, which is of type `CellGuard<'Engine>`.
    * `engine = engine_guard.contents.read;` which opens the iso for reading.
    * At the end of the scope, `engine_guard.drop()` is called which puts the iso back in the struct.


# Random

`'` can be applied to any pure function call. It will enforce that all arguments we pass in are also `'`d. Here, the compiler is automatically applying `'` to the `Engine(...)` and `Radar(...)` calls.

Design TBD: See if there are any bad interactions with universal references. Last resort, `'` calls might need a new implicit region instance with a new generation.



Accessing any owned data, like the `.engine` and `.fuel` in this example, will be zero cost.

Accessing any non-owning references, such as if `Ship` had a `fleet &Fleet`, might incur a "generation pre-check" as it reads it.
