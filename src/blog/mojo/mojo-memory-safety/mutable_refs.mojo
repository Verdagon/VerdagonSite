"""Exploring mutable references in Mojo.

Testing whether we can hold refs to fields, call mutable functions,
and still use those refs to mutate afterwards.
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


fn main():
    var point = Point(10, 20)

    # Get mutable refs to both fields
    ref x_ref = point.x
    ref y_ref = point.y

    # Can we mutate through these refs?
    x_ref = 100
    y_ref = 200

    # What if we call a mutable function in between?
    ref x_ref2 = point.x
    ref y_ref2 = point.y

    increment_x(point)  # This mutates point.x

    # Can we still mutate through the refs?
    x_ref2 = 300
    y_ref2 = 400

    # What about holding a ref to one field while mutating another?
    ref y_ref3 = point.y
    increment_x(point)  # Only modifies x
    y_ref3 = 500

