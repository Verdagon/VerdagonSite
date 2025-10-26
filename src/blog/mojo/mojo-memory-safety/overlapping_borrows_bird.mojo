@fieldwise_init
struct Wing(Copyable, Movable):
    var span: Int

    fn copy(self) -> Self:
        return Wing(self.span)


struct Bird:
    var left: Wing
    var right: Wing

    fn __init__(out self, var left: Wing, var right: Wing):
        self.left = left^
        self.right = right^

    fn copy(self) -> Self:
        return Bird(self.left.copy(), self.right.copy())


struct RefPair[left_origin: Origin, right_origin: Origin]:
    var left: Pointer[Wing, left_origin]
    var right: Pointer[Wing, right_origin]

    fn __init__(out self, ref [left_origin] left: Wing, ref [right_origin] right: Wing):
        self.left = Pointer(to=left)
        self.right = Pointer(to=right)


fn flap_left(mut bird: Bird):
    bird.left.span += 1


fn flap_left_and_return(mut bird: Bird) -> Int:
    bird.left.span += 1
    return bird.left.span


fn get_left_ref(ref bird: Bird) -> ref [bird.left] Wing:
    return bird.left


fn read_both_spans(left: Wing, right: Wing) -> Int:
    return left.span + right.span


fn modify_two(mut a: Wing, mut b: Wing):
    a.span += 2
    b.span += 3


# This won't work if the Wings are from the Bird
fn read_both_and_mutate(read a: Wing, read b: Wing, mut bird: Bird) -> Int:
    bird.left.span += 100
    return a.span + b.span + bird.left.span

fn return_wing_ref(ref [_] bird: Bird) -> ref[origin_of(bird.left)] Wing:
    return bird.left


fn add_to_wingspan(mut bird: Bird):
    bird.left.span += 1
    bird.right.span += 1


fn main():
    var bird = Bird(Wing(10), Wing(20))

    ref left_ref = bird.left
    ref right_ref = bird.right

    add_to_wingspan(bird) # Modifies Bird

    print(left_ref.span)  # Prints 11
    print(right_ref.span)  # Prints 21

    # Use the immutable references together
    var sum = read_both_spans(left_ref, right_ref)

    # Here, Mojo lazily considers bird as mutably borrowed,
    # just for this call site, even though we hold refs to its fields
    flap_left(bird)

    # The refs still work! They see the updated values
    # This demonstrates overlapping borrows - the same refs we had before
    # the mutable call are still valid!
    var sum2 = read_both_spans(left_ref, right_ref)

    # DEMONSTRATION 2: Return-Ref-Path Feature
    # Get another ref to left via a function that returns a reference
    ref left_ref_from_func = get_left_ref(bird)

    # We now have TWO overlapping refs to the same field!
    # left_ref and left_ref_from_func both refer to bird.left
    var sum3 = read_both_spans(left_ref, left_ref_from_func)

    # But what if we try to pass both as mutable refs?
    # This would error because of argument exclusivity:
    # modify_two(left_ref, left_ref_from_func)
    # error: argument of 'modify_two' call allows writing a memory location
    #        previously writable through another aliased argument

    # DEMONSTRATION 3: Refs + Mutation in Function Arguments
    # NOTE: This test FAILS with non-trivial types! It only works with register-passable
    # types like Int, because they bypass argument exclusivity checking.
    # ERROR: argument of 'read_both_and_mutate' call allows writing a memory location
    #        previously readable through another aliased argument
    # var result1 = read_both_and_mutate(left_ref, right_ref, bird)
    # This would prove activations are sequential even in function arguments,
    # but only for register-passable types!

    # DEMONSTRATION 4: Refs + Mutation in Expressions
    # In expressions, activations happen left-to-right sequentially
    var result2 = left_ref.span + flap_left_and_return(bird)

    # Same ref before and after mutation in one expression
    var result3 = left_ref.span + flap_left_and_return(bird) + left_ref.span
    # Both uses of left_ref see live values!

    # Multiple interleaved reads and mutations
    var result4 = left_ref.span + flap_left_and_return(bird) + left_ref.span + flap_left_and_return(bird) + left_ref.span

    # DEMONSTRATION 5: Structs Containing References
    # RefPair is parameterized by the origins of its two ref fields
    var pair = RefPair(left_ref, right_ref)

    # We can use the refs stored in the struct by dereferencing the pointers
    var sum_from_pair = read_both_spans(pair.left[], pair.right[])


    print("Initial: bird.left.span =", bird.left.span, ", bird.right.span =", bird.right.span)

    # Test 1: If activations overlap in call arguments
    # left_ref and right_ref would be active (immutable) for bird's wings
    # while bird is active (mutable) for the mut parameter
    # NOTE: This test FAILS with non-trivial types! It only works with register-passable
    # types like Int, because they implicitly copy.
    # ERROR: argument of 'read_both_and_mutate' call allows writing a memory location
    #        previously readable through another aliased argument
    # var resultA = read_both_and_mutate(left_ref, right_ref, bird)
    # print("Test 1 result:", resultA, "| bird.left.span is now:", bird.left.span)

    # Can we have the ref from return_wing_ref active
    # while also mutating bird in the same expression?
    # This forces keeping a reference (not copying the Wing)
    var resultE = return_wing_ref(bird).span + flap_left_and_return(bird)