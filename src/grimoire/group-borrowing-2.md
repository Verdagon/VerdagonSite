
How do we make generics work with group borrowing?

First, we'll see four example methods on a generic List struct.

 * `List<T>.sum`
 * `List<T>.append`
 * `List<T>.map`
 * `List<T>.reverse`

Then we'll see four example methods on a trait Sequence<T>.

 * `Sequence<T>.sum`
 * `Sequence<T>.append`
 * `Sequence<T>.map`
 * `Sequence<T>.reverse`


## Syntax

We'll use a Rust-like syntax with a few differences:

 * UFCS. A method and a function are the same. We'll call them all like normal functions.
 * Instead of lifetimes, we specify group paths, like in the group borrowing post.
 * There's no `&mut`. Sometimes we'll see a `mut` on parameters though, those are effects.


## `List<T>.sum`

This is a basic read-only method.

### With indices

This would look like:

```rs
fn sum<
  listG: Group<List<T>>
  initialG: Group<T>,  // isolated
  adderG: Group<impl blah blah blah>,  // isolated
  T,
>(
  list: &'listG List<T>,
  initial: 'initialG T,  // isolated
  adder: &'adderG impl Fn('initialG T, &'list.items.* T)->T,  // Closures are complex, as always
) -> T {
  let sum = initial;
  for i in 0..list.len() {
    let elem_ref: &'list.items.* T = &list[i];
    // IOW, this is a reference into the list.items.* group.

    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

Notes:

 * `adder` is in its own isolated region.
 * Do all mentions of `T` necessarily live in the same region? Tentatively, *no.* `T` is group agnostic, just a type. And therefore, `list` and `initial` are in different groups.
    * Saying Yes here might be an option too, would even be similar to Vale. Question gets nuanced (or simpler?) when we think of T as being possibly a ref type (and the ref itself is in a different group than the pointee). And in this case, `initial` is owned, but conceptually in `list.ItemsG`, similar to multi-region structs in Vale.


Sugared:

```rs
fn sum<T>(
  list: &List<T>,
  initial: T,
  adder: &impl Fn(T, &'list.ItemsG T)->T
) -> T {
  let sum = initial;
  for i in 0..list.len() {
    let elem_ref = &list[i];
    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

`list.Items` instead of `list.items.*` because `List<T>` contains an associated group `comptime var Items = self.items.*`


### With iterator

This would look like:

```rs
fn sum<
  listG: Group<List<T>>,
  initialG: Group<T>,  // isolated
  adderG: Group<impl blah blah blah>,  // isolated
  T,
>(
  list: &'listG List<T>,
  initial: 'initialG T,
  adder: &'adderG impl Fn('initialG T, &'list.items.* T)->T,  // Closures are complex, as always
) -> T {
  let sum = initial;
  let iter: ListIterator<'listG, T> = list.iter();
  loop {
    let maybe_elem_ref: Option<&'listG.items.* T> = iter.next();
    let Some(elem_ref: &'listG.items.* T) = maybe_elem_ref else { break; }

    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

Sugared:

```rs
fn sum<T>(
  list: &List<T>,
  initial: T,
  adder: &impl Fn(T, &'list.ItemsG T)->T
) -> T {
  let sum = initial;
  for elem_ref in list.iter() {
    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

### Variants and avoided complications

 * We can also imagine a variant that requires that T be addable. I think it would be a straightforward change from this, worth exploring later.
 * If we had a version that took in an &initial, we might want to support overlaps, because of this situation: if we know there's >=1 element in the list, we might want to do list[1..].sum(list[0]). In which case these might be in the same group. So we should probably *allow* them being in the same region.
 * Note that the adder is a pure function (no mut effects) so they don't invalidate our list iterator struct. We'll see an example of enforcing that for an impure function further below.
 * We dont need to worry about any incoming groups aliasing any other incoming groups here. We'll run into that later.


## `List<T>.append`

```rs
fn append<
  listG: Group<List<T>>
  newElemG: Group<T>,  // isolated
  T,
>(
  list: &'listG List<T> mut,
  new_elem: 'newElemG T  // implicit mut since we're taking ownership
) {
  if list.size == list.capacity {
    let old_items = list.items; // moves, mut list.items effect
    list.capacity *= 2; // also mut list effect (might be unnecessary?)
    list.items = Array[T](list.capacity)
    // TODO: move items over, mut list.items.* effect
  }
  list.items[list.size] = new_elem; // moves, mut list.items.* effect
  list.size++; // mut list effect
  return sum
}
```

Notes:

 * It knows nothing aliases new_elem because it was moved in (spidey sense tingles here, think on this, think about rvalue refs)
 * This is another case where the parameters don't need to alias. Another data point suggesting maybe disjoint should be default?
 * `T` itself doesn't contain any information about the path it's in. `&T` would. In other words, path is a property of a reference.
    * We should still be able to move a `T` from one group to another. That's most moves, actually.

Sugared:

```rs
fn append<T>(list: &List<T> mut, new_elem: T) {
  if list.size == list.capacity {
    let old_items = list.items; // moves, mut list.items effect
    list.capacity *= 2; // also mut list effect (might be unnecessary?)
    list.items = Array[T](list.capacity)
    // TODO: move items over, mut list.items.* effect
  }
  list.items[list.size] = new_elem; // moves, mut list.items.* effect
  list.size++; // mut list effect
  return sum
}
```


## `List<T>.map`

### With indices

Similar to `sum`, but it assembles a new List.

The biggest complication comes from the fact that the given closure might mutate via captures, so we need to propagate those mutations upward to our caller (`mut E`)`.

```rs
fn map<
  R,
  listG: Group<List<T>>,
  T,
  fG: Group<impl blah blah blah>,  // isolated
  E: MutEffects
>(
  list: &'listG List<T>,
  f: &'fG impl Fn(&'list.items.* T) mut E -> R,
) mut E -> List<R> {
  let result = List<R>()
  for (i = 0; i < list.len(); i++) {
    result.add((f)(list[i]));
  }
  return result
}
```

Notes:

 * There's no `mut` effect on the `f` parameter so we can't modify anything _owned_ by the closure, with this code. We could add that in though. It would be an FnMut basically (or maybe something like a `Fn(&self mut, ...`)

Sugared:

```rs
// list and f cant overlap.
// can we communicate memory effects from F to our caller?
// especially tricky when we consider that its a closure.
fn map<R, T, E: MutEffects>(
  list: &List<T>,
  f: &impl Fn(&'list.ItemsG T) mut E -> R,
) mut E -> List<R> {
  let result = List<R>()
  for (i = 0; i < list.len(); i++) {
    result.add((f)(list[i]));
  }
  return result
}
```


### With iterators

Similar to the last one, but we need to prevent iterator invalidation.

So, we need to restrict the given closure from mutating the list itself. We'll do that with a **downward effect**, or putting a constraint on a callee. In this case where we have both (`mut E !mut list.items`) you can almost think of it like a subtraction, `E` can have mutations but not `list.items` (or anything above it).

We'll want downward effects for other things too later on, like compile-time RefCells.

```rs
fn map<
  R,
  listG: Group<List<T>>,
  T,
  fG: Group<impl blah blah blah>,  // isolated
  E: MutEffects
>(
  list: &'listG List<T>,
  f: &'fG impl Fn(&'list.items.* T) mut E !mut list.items -> R,
) mut E -> List<R> {
  let result = List<R>()
  for x in list {
    result.add((f)(x));
  }
  return result
}
```

(This is likely similar to a `SomeStruct<'something.blah>` is a struct that should freeze `something.blah`)

Sugared:

```rs
fn map<R, T, E: MutEffects>(
  list: &List<T>,
  f: &impl Fn(&'list.ItemsG T) mut E !mut list.items -> R,
) mut E -> List<R> {
  let result = List<R>()
  for x in list {
    result.add((f)(x));
  }
  return result
}
```

## `List<T>.reverse`


### Closure allows aliasing

```rs
fn reverse<
  listG: Group<List<T>>,
  T,
  swapperG: Group<impl blah blah blah>,
>(
  list: &'listG List<T> mut .items.*,
  // The closure's two params have the same group, so theyre allowed to alias
  swapper: &'swapperG impl Fn(&'list.items.* T mut, &'list.items.* T mut) -> R,
) {
  for i in range(0, list.len() / 2) {
    let i_ref = &list[i];
    let far_ref = &list[list.len() - i];
    swapper(i_ref, far_ref)
  }
}
```

Notes:

 * This only allows the closure to modify the items. We could allow it to modify anything, like `map`. Would be particularly easy here since we're using indices.
 * The closure expects two references that may alias each other. See usage below for how it deals with that.

Sugared:

```rs
fn reverse<T>(
  list: &List<T> mut .Items,
  swapper: &impl Fn(&'list.ItemsG T mut, &'list.ItemsG T mut) -> R,
) {
  for i in range(0, list.len() / 2) {
    let i_ref = &list[i];
    let far_ref = &list[list.len() - i];
    swapper(i_ref, far_ref) // this requires an effect to modify list.items.*
  }
}
```

Usage:

```rs
fn swap_ships<G: Group<Ship>>(a_ref: &'G Ship mut, b_ref: &'G Ship mut) {
  if disjoint(a, b) { // Convinces the compiler that a_ref and b_ref are different
    let x = a_ref; // Compiler knows this only destroys a_ref, not b_ref
    a_ref = b_ref; // Compiler knows this reinitializes a_ref, destroys b_ref
    b_ref = x; // Compiler knows this reinitializes b_ref, destroys x
  }
}

fn main() {
  let list = list![Ship(1), Ship(2), Ship(3), Ship(4), Ship(5)];
  reverse(&list, swap_ships);
}
```

(A bit noisy, and needing `disjoint` is meh, TODO design out this area more)


### Optional side quest: closure requiring disjoint

#### Full Rust approach

If we don't want the closure to use `if disjoint` then the closure needs to take in two references that it knows don't alias each other.

One way to do that is to do the Rust approach, of handing it unique references (`&uni`, equivalent to rust `&mut`) to the closure. To do this, it requires the `list` parameter also be `&uni`. This has effects on its callers.

```rs
fn reverse<
  listG: Group<List<T>>,
  T,
  swapperG: Group<impl blah blah blah>,
>(
  list: &'listG uni List<T> mut,
  // This doesn't specify that the first param and second param can alias,
  // so they aren't allowed to alias.
  swapper: &'swapperG impl Fn(&uni T mut, &uni T mut) -> R,
) {
  // TODO: probably use something like split_at_mut and a loop
}
```

We probably don't have to go full Rust here. There's undoubtedly a way to specify that we're handing in two unequal references into the same group.

Sugared:

```rs
fn reverse<T>(
  list: &uni List<T> mut,
  // This doesn't specify that the first param and second param can alias,
  // so they aren't allowed to alias.
  swapper: &impl Fn(&uni T mut, &uni T mut) -> R,
) {
  // TODO: probably use something like split_at_mut and a loop
}
```


#### Other approach

TBD

I think there might be a way to specify that a function receives two disjoint references into the same group.

```rs
fn reverse<T>(
  list: &List<T> mut .items.*,
  // This doesn't specify that the first param and second param can alias,
  // so they aren't allowed to alias.
  swapper: &impl Fn(&'list.items.* uni T mut, &'list.items.* uni T mut) -> R,
) {
  for i in range(0, list.len() / 2) {
    let i_ref = &list[i];
    let far_ref = &list[list.len() - i];
    if disjoint(i_ref, far_ref) {
      swapper(i_ref, far_ref) // this requires an effect to modify list.items.*
    }
  }
}

fn swap_ships<G: Group<Ship>>(a_ref: &'G uni Ship mut, b_ref: &'G uni Ship mut) {
  let x = a_ref; // Compiler knows this only destroys a_ref, not b_ref
  a_ref = b_ref; // Compiler knows this reinitializes a_ref, destroys b_ref
  b_ref = x; // Compiler knows this reinitializes b_ref, destroys x
}

fn main() {
  let list = list![Ship(1), Ship(2), Ship(3), Ship(4), Ship(5)];
  reverse(&list, swap_ships);
}
```

Might be elegant, might be a can of worms, TBD.

One challenge will be making sure that the callee doesn't (use a closure capture to) derive another reference into that same group. Perhaps it would be fine if they try, as long as they don't use the `uni` references while its alive?

Perhaps `uni` is the wrong concept. Maybe we should have a "disjoint variable set", where N variables are known to all be different than each other.



## `Sequence`

Below sections will use this Sequence trait:

```rs
trait Sequence<T> {
  associated ItemsG: Group<T> where 'ItemsG in 'SelfG;

  fn len(self: &Sequence<T>) -> int;
  fn __index(self: &Sequence<T>, i: int) -> &'itemG T;
  
  associated Iter: Iterator<'SelfG, 'ItemsG, T>
}

trait Iterator<ItemsG: Group<T>, T> {
  fn next(self: &Self mut) -> Option<&'ItemsG T>;
}
```

Notes:

 * `SelfG` is `self`'s group
 * `where 'ItemsG in 'SelfG` might not be necessary, TBD. Perhaps it would be assumed in a struct but not a trait (similar to autogenerated destructors)


## `Sequence<T>.sum`

This is a basic read-only method.

### With indices

This would look like:

```rs
fn sum<
  S: Sequence<T>,
  seqG: Group<S>,
  initialG: Group<T>,  // isolated
  adderG: Group<impl blah blah blah>,  // isolated
  T,
>(
  seq: &'seqG Sequence<T>,
  initial: 'initialG T,  // isolated
  adder: &'adderG impl Fn('initialG T, &'seq.ItemsG T)->T,  // Closures are complex, as always
) -> T {
  let sum = initial;
  for i in 0..seq.len() {
    let elem_ref: &'seq.ItemsG T = &seq[i];
    // IOW, this is a reference into the seq.Items group.

    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

Notes:

 * `adder` is in its own isolated region.
 * Do all mentions of `T` necessarily live in the same region? Tentatively, *no.* `T` is group agnostic, just a type. And therefore, `seq` and `initial` are in different groups.
    * Saying Yes here might be an option too, would even be similar to Vale. Question gets nuanced (or simpler?) when we think of `T` as being possibly a ref type (and the ref itself is in a different group than the pointee). And in this case, `initial` is owned, but conceptually in `seq.Items`, similar to multi-region structs in Vale.


Sugared:

```rs
fn sum<T>(
  seq: &impl Sequence<T>,
  initial: T,
  adder: &impl Fn(T, &'seq.ItemsG T)->T
) -> T {
  let sum = initial;
  for i in 0..seq.len() {
    let elem_ref = &seq[i];
    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```


### With iterator

This would look like:

```rs
fn sum<
  S: Sequence<T>,
  seqG: Group<S>
  initialG: Group<T>,  // isolated
  adderG: Group<impl blah blah blah>,  // isolated
  T,
>(
  seq: &'seqG S,
  initial: 'initialG T,
  adder: &'adderG impl Fn('initialG T, &'seq.items.* T)->T,  // Closures are complex, as always
) -> T {
  let sum = initial;
  let iter: Iterator<'seqG, seq.ItemsG, T> = seq.iter();
  loop {
    let maybe_elem_ref: Option<&'seqG.items.* T> = iter.next();
    let Some(elem_ref: &'seqG.items.* T) = maybe_elem_ref else { break; }

    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```

Sugared:

```rs
fn sum<T>(
  seq: &impl Sequence<T>,
  initial: T,
  adder: &impl Fn(T, &'seq.ItemsG T)->T
) -> T {
  let sum = initial;
  for elem_ref in seq.iter() {
    sum = adder(sum, elem_ref); // moves sum, reinitializes sum
  }
  return sum
}
```


## `Sequence<T>.append`

### `new_elem` non-overlapping

```rs
fn append<
  S: Sequence<T>,
  seqG: Group<S>,
  newElemG: Group<T>,  // isolated
  T,
>(
  seq: &'seqG S mut,
  new_elem: 'newElemG T  // implicit mut since we're taking ownership
);
```

Notes:

 * It knows nothing aliases `new_elem` because it was moved in (spidey sense tingles here, think on this, think about rvalue refs)
 * This is another case where the parameters don't need to alias. Another data point suggesting maybe disjoint should be default?
 * `T` itself doesn't contain any information about the path it's in. `&T` would. In other words, path is a property of a reference.
    * We should still be able to move a `T` from one group to another. That's most moves, actually.

Sugared:

```rs
fn append<T>(list: &impl Sequence<T> mut, new_elem: T);
```

### `new_elem` maybe overlapping

```rs
fn append<
  seqG: Group<Sequence<T>>,
  newElemG: Group<T>,
  T,
>(
  seq: &'seqG Sequence<T> mut,
  new_elem: 'newElemG T  // implicit mut since we're taking ownership
) may_overlap(seq.ItemsG, newElemG);
```

`may_overlap` is a way to signal to the system that two groups might be aliasing. It's not strictly necessary here, so not a great example. See the next section for more details on `may_overlap`.

Sugared:

```rs
trait Sequence<T> {
  ...
  fn append<T>(list: &Self mut, new_elem: T may_overlap list.ItemsG);
}
```

or:

```rs
fn append<T>(list: &impl Sequence<T> mut, new_elem: T may_overlap list.ItemsG);
```


## `may_overlap`

Here's a better example of `may_overlap`.

It's a function that takes elements from one list and adds them, reversed, into another list.

This should be correctly REJECTED by the compiler:

```rs
fn copy_all_into<
  ListAG: Group<List<T>>,
  ListBG: Group<List<T>>,
  T: Copyable,
>(
  list_a: &List<T> mut,
  list_b: &List<T>
) may_overlap(ListAG, ListBG) {
  let list_b_iter: ListIterator<'ListBG.ItemsG, T> = list_b_list.iter();
  loop {
    // Error: cannot call iter.next() on invalidated ListIterator<'ListBG.ItemsG, T>
    // because 'ListBG.ItemsG was invalidated, because...
    let maybe_b_elem_ref: Option<&'ListBG.ItemsG T> = iter.next();
    let Some(b_elem_ref: &'ListBG.ItemsG T) = maybe_b_elem_ref else { break; }

    // Note: ...list_a.append mutated group ListAG.ItemsG...
    list_a.append(b_elem_ref.copy());
    // Note: ...which may_overlap with ListBG.ItemsG.
  }
}
```

Sugared:

```rs
fn copy_all_into<T>(list_a: &List<T> mut, list_b: &List<T>) may_overlap(list_a, list_b) {
  // Error: cannot iterate over list_b because it may_overlap with list_a...
  for x in list_b {
    // Note: ...which is invalidated by this list_a.append call.
    list_a.append(b_elem_ref.copy());
  }
}
```

Details: If groups A and B overlap, then:

 * Mutations to A will invalidate references to inside B, and vice versa.
 * The compiler will not allow assigning between them. EG we can't `let a_elem = b_elem`, because we don't _know_ that they're the same group.


Fix 1 for the above: remove `may_overlap`.

Fix 2 for the above: use indices:

```rs
fn copy_all_into<T>(list_a: &List<T> mut, list_b: &List<T>) may_overlap(list_a, list_b) {
  for i in 0..list_b.len() {
    list_a.append(list_b[i].copy());
  }
}
```

Fix 3 for the above: use `if disjoint`:

```rs
fn copy_all_into<T>(list_a: &List<T> mut, list_b: &List<T>) may_overlap(list_a, list_b) {
  if disjoint(list_a, list_b) {
    for x in list_b {
      list_a.append(b_elem_ref.copy());
    }
  } else {
    ...
  }
}
```

More notes:

 * In pure functions, for ergonomic reasons, we can assume everything `may_overlap`, that's fine.
 * TBD sugar: Should the compiler ever assume `may_overlap`? For example if we hand in two `&Ship`, should it assume may_overlap?
    * Perhaps Yes:
       * More ergonomic perhaps? More spiritually true to group borrowing's purpose? Possibly more compatible with holy grail?
    * Perhaps No:
       * The function starts strict and is loosened later, which seems like good practice. APIs can loosen restrictions in non-breaking ways.


## `Sequence<T>.map`

### With indices

Similar to `sum`, but it assembles a new List.

The biggest complication comes from the fact that the given closure might mutate via captures, so we need to propagate those mutations upward to our caller (`mut E`)`.

```rs
fn map<
  R,
  S: Sequence<T>,
  seqG: Group<S>,
  T,
  fG: Group<impl blah blah blah>,  // isolated
  E: MutEffects
>(
  seq: &'seqG S,
  f: &'fG impl Fn(&'seq.ItemsG T) mut E -> R,
) mut E -> Sequence<R> {
  let result = Sequence<R>()
  for (i = 0; i < seq.len(); i++) {
    result.add((f)(seq[i]));
  }
  return result
}
```

Notes:

 * There's no `mut` effect on the `f` parameter so we can't modify anything _owned_ by the closure, with this code. We could add that in though. It would be an FnMut basically (or maybe something like a `Fn(&self mut, ...`)

Sugared:

```rs
fn map<R, T, E: MutEffects>(
  seq: &impl Sequence<T>,
  f: &impl Fn(&'seq.ItemsG T) mut E -> R,
) mut E -> Sequence<R> {
  let result = Sequence<R>()
  for (i = 0; i < seq.len(); i++) {
    result.add((f)(seq[i]));
  }
  return result
}
```


### With iterators

Similar to the last one, but we need to prevent iterator invalidation.

So, we need to restrict the given closure from mutating the list itself. We'll do that with a **downward effect**, or putting a constraint on a callee. In this case where we have both (`mut E !mut list.items`) you can almost think of it like a subtraction, `E` can have mutations but not `list.items` (or anything above it).

We'll want downward effects for other things too later on, like compile-time RefCells.

```rs
fn map<
  R,
  S: Sequence<T>,
  seqG: Group<S>,
  T,
  fG: Group<impl blah blah blah>,  // isolated
  E: MutEffects
>(
  seq: &'seqG S,
  f: &'fG impl Fn(&'seq.ItemsG T) mut E !mut seq.ItemsG -> R,
) mut E -> List<R> {
  let result = List<R>();
  for x in seq {
    result.add((f)(x));
  }
  return result
}
```

(This is likely similar to a `SomeStruct<'something.blah>` is a struct that should freeze `something.blah`)

Sugared:

```rs
fn map<R, T, E: MutEffects>(
  seq: &impl Sequence<T>,
  f: &impl Fn(&'seq.ItemsG T) mut E !mut seq.ItemsG -> R,
) mut E -> List<R> {
  let result = List<R>()
  for x in seq {
    result.add((f)(x));
  }
  return result
}
```


## `Sequence<T>.reverse`

### Closure allows aliasing

```rs
fn reverse<
  S: Sequence<T>,
  seqG: Group<S>,
  T,
  swapperG: Group<Sequence blah blah blah>,
>(
  seq: &'seqG S mut .ItemsG,
  // The closure's two params have the same group, so theyre allowed to alias
  swapper: &'swapperG impl Fn(&'seq.ItemsG T mut, &'seq.ItemsG T mut) -> R,
) {
  for i in range(0, seq.len() / 2) {
    let i_ref = &seq[i];
    let far_ref = &seq[seq.len() - i];
    swapper(i_ref, far_ref)
  }
}
```

Notes:

 * This only allows the closure to modify the items. We could allow it to modify anything, like `map`. Would be particularly easy here since we're using indices.
 * The closure expects two references that may alias each other. See usage below for how it deals with that.

Sugared:

```rs
fn reverse<T>(
  seq: &impl Sequence<T> mut .Items,
  swapper: &impl Fn(&'seq.ItemsG T mut, &'seq.ItemsG T mut) -> R,
) {
  for i in range(0, seq.len() / 2) {
    let i_ref = &seq[i];
    let far_ref = &seq[seq.len() - i];
    swapper(i_ref, far_ref) // this requires an effect to modify seq.ItemsG
  }
}
```

Usage:

```rs
fn swap_ships<G: Group<Ship>>(a_ref: &'G Ship mut, b_ref: &'G Ship mut) {
  if disjoint(a, b) { // Convinces the compiler that a_ref and b_ref are different
    let x = a_ref; // Compiler knows this only destroys a_ref, not b_ref
    a_ref = b_ref; // Compiler knows this reinitializes a_ref, destroys b_ref
    b_ref = x; // Compiler knows this reinitializes b_ref, destroys x
  }
}

fn main() {
  let list = list![Ship(1), Ship(2), Ship(3), Ship(4), Ship(5)];
  reverse(&list, swap_ships);
  // Infers that T is Ship,
}
```

Possible sugar: auto-declared groups:

```rs
// Equivalent
fn swap_ships<G: Group<Ship>>(a_ref: &'G Ship mut, b_ref: &'G Ship mut)
fn swap_ships(a_ref: &'G Ship mut, b_ref: &'G Ship mut)
```


## Notes

Interfaces/Traits

Mutations to a'ILaunchable will count as mutations to a'Ship and a'Boat. But only comes into play with `may_overlap` is present.

Do we want squishy paths? for example, `All.Entity...` means this is a reference to something anywhere inside Entity. any edits to Entity will invalidate it.

AHA there is a difference between `mut entity: [level.entities.*] Entity` and `entity: Entity) {mut level.entities.*}`. the first one says that mutations will happen through *this specific reference*, the second says that mutations will happen to any object.
the first one is slightly better because it means that if the caller knows that two entities arent equal, and they pass in one, theyll know the other hasnt changed.
this might actually be the same thing as may_overlap.
