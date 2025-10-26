// Rust version that FAILS to compile
// This demonstrates the exact errors you get when trying to do what Mojo allows

struct Point {
    x: i32,
    y: i32,
}

fn increment_x(point: &mut Point) {
    point.x += 1;
}

fn main() {
    let mut point = Point { x: 10, y: 20 };

    // ERROR 1: Cannot hold mutable refs to multiple fields and use them
    // (Actually, this specific case works in Rust due to split borrowing)
    let x_ref = &mut point.x;
    let y_ref = &mut point.y;  // OK - different fields
    *x_ref = 100;
    *y_ref = 200;

    // ERROR 2: Cannot hold a ref and call a mutable function on the whole struct
    let x_ref2 = &mut point.x;
    increment_x(&mut point);  // ERROR: cannot borrow `point` as mutable more than once
    *x_ref2 = 300;  // This line is unreachable due to the error above

    // ERROR 3: Cannot hold a ref to one field while calling mutable function
    let y_ref3 = &mut point.y;
    increment_x(&mut point);  // ERROR: cannot borrow `point` as mutable because `point.y` is already borrowed
    *y_ref3 = 500;  // This line is unreachable due to the error above
}
