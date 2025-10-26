struct Point:
    var x: Int
    var y: Int

    fn __init__(out self, x: Int, y: Int):
        self.x = x
        self.y = y


struct RefPair[x_origin: Origin, y_origin: Origin]:
    var x: Pointer[Int, x_origin]
    var y: Pointer[Int, y_origin]

    fn __init__(out self, ref [x_origin] x: Int, ref [y_origin] y: Int):
        self.x = Pointer(to=x)
        self.y = Pointer(to=y)


fn increment_x(mut point: Point):
    point.x += 1


fn increment_x_and_return(mut point: Point) -> Int:
    point.x += 1
    return point.x


fn read_both_and_mutate(a: Int, b: Int, mut point: Point) -> Int:
    # This tests if a and b (from point's fields) can coexist with mut point
    point.x += 100
    return a + b + point.x

fn get_x_ref(ref point: Point) -> ref [origin_of(point.x)] Int:
    return point.x


fn read_both(x: Int, y: Int) -> Int:
    return x + y


fn swap_two(mut a: Int, mut b: Int):
    var temp = a
    a = b
    b = temp


fn main():
    var point = Point(10, 20)

    # DEMONSTRATION 1: Overlapping Field References
    # Create overlapping references to different fields
    # In Rust, you couldn't hold these refs and then call a mut function
    ref x_ref = point.x
    ref y_ref = point.y

    # Use the immutable references together
    var sum = read_both(x_ref, y_ref)

    # Here, Mojo lazily considers point as mutably borrowed,
    # just for this call site, even though we hold refs to its fields
    increment_x(point)

    # The refs still work! They see the updated values
    # This demonstrates overlapping borrows - the same refs we had before
    # the mutable call are still valid!
    var sum2 = read_both(x_ref, y_ref)

    # DEMONSTRATION 2: Return-Ref-Path Feature
    # Get another ref to x via a function that returns a reference
    ref x_ref_from_func = get_x_ref(point)

    # We now have TWO overlapping refs to the same field!
    # x_ref and x_ref_from_func both refer to point.x
    var sum3 = read_both(x_ref, x_ref_from_func)

    # But what if we try to pass both as mutable refs?
    # This would error because of argument exclusivity:
    # swap_two(x_ref, x_ref_from_func)
    # error: argument of 'swap_two' call allows writing a memory location
    #        previously writable through another aliased argument

    # DEMONSTRATION 3: Refs + Mutation in Function Arguments
    # Test if x_ref and y_ref (from point) can coexist with mut point
    # in the same function call
    var result1 = read_both_and_mutate(x_ref, y_ref, point)
    # This proves activations are sequential even in function arguments!

    # DEMONSTRATION 4: Refs + Mutation in Expressions
    # In expressions, activations happen left-to-right sequentially
    var result2 = x_ref + increment_x_and_return(point)

    # Same ref before and after mutation in one expression
    var result3 = x_ref + increment_x_and_return(point) + x_ref
    # Both uses of x_ref see live values!

    # Multiple interleaved reads and mutations
    var result4 = x_ref + increment_x_and_return(point) + x_ref + increment_x_and_return(point) + x_ref

    # DEMONSTRATION 5: Structs Containing References
    # RefPair is parameterized by the origins of its two ref fields
    var pair = RefPair(x_ref, y_ref)

    # We can use the refs stored in the struct by dereferencing the pointers
    var sum_from_pair = read_both(pair.x[], pair.y[])
