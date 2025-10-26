"""Demonstration of Mojo's field references and mutable borrows.

This explores how Mojo handles references to struct fields and what happens
when you need a mutable borrow for a function call.
"""

struct Point:
    var x: Int
    var y: Int

    fn __init__(out self, x: Int, y: Int):
        self.x = x
        self.y = y


fn increment_x(mut point: Point):
    """Takes a mutable reference and modifies x."""
    point.x += 1


fn increment_both(mut point: Point):
    """Takes a mutable reference and modifies both fields."""
    point.x += 1
    point.y += 1


fn read_x(point: Point) -> Int:
    """Takes an immutable borrow."""
    return point.x


fn read_both_fields(point: Point) -> Int:
    """Takes an immutable borrow and reads both fields."""
    return point.x + point.y


fn main():
    var point = Point(10, 20)

    # Can we have overlapping immutable borrows of the whole struct?
    var sum1 = read_both_fields(point)
    var sum2 = read_both_fields(point)
    var sum3 = read_both_fields(point)

    # Mixing field access and whole-struct borrows
    ref x_ref = point.x
    var whole_sum = read_both_fields(point)  # Can we borrow whole struct while holding field ref?

    # Calling mutable function
    increment_x(point)

    # Alternating mutable and immutable operations
    ref before_x_ref = point.x
    increment_x(point)
    ref after_x_ref = point.x

    # Interleave reads and writes to different fields
    ref y_ref = point.y
    increment_x(point)  # Modifies x only
    # y_ref still valid and unchanged
