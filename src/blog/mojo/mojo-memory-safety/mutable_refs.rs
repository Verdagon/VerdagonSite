// Rust version demonstrating borrow checker restrictions
// This shows where Rust is more restrictive than Mojo

struct Point {
    x: i32,
    y: i32,
}

fn increment_x(point: &mut Point) {
    point.x += 1;
}

fn main() {

    let mut point = Point { x: 10, y: 20 };

    // Example 1: Can we hold refs to both fields simultaneously and mutate?
    let x_ref = &mut point.x;
    // ERROR: cannot borrow `point.y` as mutable because `point.x` is already borrowed
    // let y_ref = &mut point.y;  // This would fail!
    *x_ref = 100;

    // Example 2: Can we hold a ref, call a mutable function, then use the ref?
    let x_ref2 = &mut point.x;

    // ERROR: cannot borrow `point` as mutable because `point.x` is already borrowed
    // increment_x(&mut point);  // This would fail!

    // We have to use the ref before the mutable call
    *x_ref2 = 200;

    // Now we can call the mutable function
    increment_x(&mut point);

    // Example 3: Can we hold a ref to one field while mutating another?
    let y_ref = &mut point.y;

    // ERROR: cannot borrow `point` as mutable because `point.y` is already borrowed
    // increment_x(&mut point);  // This would fail!

    // We have to finish with y_ref first
    *y_ref = 500;

    // Now we can call increment_x
    increment_x(&mut point);

    // Example 4: The workaround - split borrows
    let x_ref3 = &mut point.x;
    let y_ref3 = &mut point.y;  // This works because we borrow different fields!
    *x_ref3 = 1000;
    *y_ref3 = 2000;

    // But still can't call increment_x while holding these refs:
    // increment_x(&mut point);  // Would fail!
}
