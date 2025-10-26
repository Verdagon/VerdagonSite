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

fn holds_ref(ref [_] x: Wing) -> ref [origin_of(x)] Wing:
    return x

fn identity_ref(ref [_] x: Wing) -> ref [origin_of(x)] Wing:
    return x

fn read_two_wings(read a: Wing, read b: Wing) -> Int:
    return a.span + b.span

fn swap_two_wings(mut a: Wing, mut b: Wing):
    var temp = a.span
    a.span = b.span
    b.span = temp

fn main():
    var bird = Bird(Wing(10), Wing(20))
    ref left_ref = bird.left
    
    print("=== TEST 1: Origin preservation through function return ===")
    ref permanent_ref = holds_ref(left_ref)
    print("Created permanent_ref from left_ref")
    print("left_ref.span:", left_ref.span)
    print("permanent_ref.span:", permanent_ref.span)
    
    print("\n=== TEST 2: Both refs can read the same field ===")
    var sum = read_two_wings(left_ref, permanent_ref)
    print("read_two_wings(left_ref, permanent_ref) =", sum)
    print("SUCCESS: Two refs to same origin can both activate immutably")
    
    print("\n=== TEST 3: Both refs see mutations ===")
    _ = flap_left(bird)
    print("After flap_left(bird):")
    print("left_ref.span:", left_ref.span)
    print("permanent_ref.span:", permanent_ref.span)
    print("SUCCESS: Both refs see the updated value")
    
    print("\n=== TEST 4: Both refs can be used in same expression ===")
    var result = left_ref.span + permanent_ref.span + flap_left(bird)
    print("left_ref.span + permanent_ref.span + flap_left(bird) =", result)
    print("SUCCESS: Sequential activations work")
    
    print("\n=== TEST 5: Cannot swap using both refs (exclusivity) ===")
    print("Attempting: swap_two_wings(left_ref, permanent_ref)")
    # This should ERROR because both would be mutably active to same origin
    # swap_two_wings(left_ref, permanent_ref)
    print("COMMENTED OUT: Would fail with exclusivity error")
    
    print("\n=== TEST 6: Chaining ref returns ===")
    ref chained_ref = identity_ref(holds_ref(left_ref))
    print("Created chained_ref via identity_ref(holds_ref(left_ref))")
    print("chained_ref.span:", chained_ref.span)
    
    print("\n=== TEST 7: All three refs to same origin ===")
    var triple_sum = read_two_wings(left_ref, chained_ref)
    print("read_two_wings(left_ref, chained_ref) =", triple_sum)
    
    var all_three = left_ref.span + permanent_ref.span + chained_ref.span
    print("left_ref.span + permanent_ref.span + chained_ref.span =", all_three)
    print("SUCCESS: All three refs share the same origin and can coexist")
    
    print("\n=== TEST 8: Cannot mutably use any pair of the three ===")
    print("All of these would fail with exclusivity errors:")
    print("  swap_two_wings(left_ref, permanent_ref)")
    print("  swap_two_wings(left_ref, chained_ref)")
    print("  swap_two_wings(permanent_ref, chained_ref)")
    print("REASON: All three have origin_of(bird.left)")
    
    print("\n=== TEST 9: Create ref from one of the derived refs ===")
    ref meta_ref = holds_ref(permanent_ref)
    print("Created meta_ref from permanent_ref (which came from left_ref)")
    print("meta_ref.span:", meta_ref.span)
    var quad_sum = left_ref.span + permanent_ref.span + chained_ref.span + meta_ref.span
    print("Sum of all four refs:", quad_sum)
    print("SUCCESS: Origin tracking preserves through multiple levels")
    
    print("\n=== TEST 10: Different field - different origin ===")
    ref right_ref = bird.right
    var left_right_sum = read_two_wings(left_ref, right_ref)
    print("read_two_wings(left_ref, right_ref) =", left_right_sum)
    print("SUCCESS: Different origins (bird.left vs bird.right) can coexist")
    
    # This SHOULD work because different origins
    print("\n=== TEST 11: Can swap different origins ===")
    swap_two_wings(left_ref, right_ref)
    print("swap_two_wings(left_ref, right_ref) succeeded")
    print("After swap: bird.left.span =", bird.left.span, ", bird.right.span =", bird.right.span)
    print("SUCCESS: Mutable activations of different origins allowed")