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

fn flap_left(mut bird: Bird) -> Int:
    bird.left.span += 1
    return bird.left.span

# This won't work if the Wings are from the Bird
fn read_both_and_mutate(read a: Wing, read b: Wing, mut bird: Bird) -> Int:
    bird.left.span += 100
    return a.span + b.span + bird.left.span

fn return_wing_ref(ref [_] bird: Bird) -> ref[origin_of(bird.left)] Wing:
    return bird.left

fn main():
    var bird = Bird(Wing(10), Wing(20))
    ref left_ref = bird.left
    ref right_ref = bird.right

    print("Initial: bird.left.span =", bird.left.span, ", bird.right.span =", bird.right.span)

    # Test 1: If activations overlap in call arguments
    # left_ref and right_ref would be active (immutable) for bird's wings
    # while bird is active (mutable) for the mut parameter
    # NOTE: This test FAILS with non-trivial types! It only works with register-passable
    # types like Int, because they implicitly copy.
    # ERROR: argument of 'read_both_and_mutate' call allows writing a memory location
    #        previously readable through another aliased argument
    # var result1 = read_both_and_mutate(left_ref, right_ref, bird)
    # print("Test 1 result:", result1, "| bird.left.span is now:", bird.left.span)

    # Test 2: If activations can overlap within expression evaluation
    # Here left_ref would need to be active (for the final addition)
    # while flap_left mutably activates bird
    var result2 = left_ref.span + flap_left(bird)
    print("Test 2 result:", result2, "| bird.left.span is now:", bird.left.span)

    # Test 3: More complex - left_ref active at start and end
    # while bird mutably active in middle
    var result3 = left_ref.span + flap_left(bird) + left_ref.span
    print("Test 3 result:", result3, "| bird.left.span is now:", bird.left.span)

    # Test 4: Multiple immutable activations of same ref
    # while mutating the source in between (in same expression)
    var result4 = left_ref.span + flap_left(bird) + left_ref.span + flap_left(bird) + left_ref.span
    print("Test 4 result:", result4, "| bird.left.span is now:", bird.left.span)

    # Can we have the ref from return_wing_ref active
    # while also mutating bird in the same expression?
    # This forces keeping a reference (not copying the Wing)
    var result5 = return_wing_ref(bird).span + flap_left(bird)