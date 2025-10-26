// Rust version demonstrating borrow checker restrictions
// Uncomment ONE function at a time to see each specific error or success

struct Point {
    x: i32,
    y: i32,
}

fn increment_x(point: &mut Point) {
    point.x += 1;
}

// SUCCESS: Can hold one mutable field ref and use it
fn success_single_field_ref() {
    let mut point = Point { x: 10, y: 20 };
    let x_ref = &mut point.x;
    *x_ref = 100;
}

// ERROR: Cannot hold mutable refs to two fields simultaneously
fn error_multiple_field_refs() {
    let mut point = Point { x: 10, y: 20 };
    let x_ref = &mut point.x;
    let y_ref = &mut point.y;  // ERROR: cannot borrow `point.y` as mutable because `point.x` is already borrowed
    *x_ref = 100;
    *y_ref = 200;
}

// SUCCESS: Can call mutable function if no refs are held
fn success_call_mut_no_refs() {
    let mut point = Point { x: 10, y: 20 };
    increment_x(&mut point);
}

// ERROR: Cannot call mutable function while holding field ref
fn error_call_mut_with_field_ref() {
    let mut point = Point { x: 10, y: 20 };
    let x_ref = &mut point.x;
    increment_x(&mut point);  // ERROR: cannot borrow `point` as mutable because `point.x` is already borrowed
    *x_ref = 200;
}

// ERROR: Cannot call mutable function while holding ref to different field
fn error_call_mut_with_other_field_ref() {
    let mut point = Point { x: 10, y: 20 };
    let y_ref = &mut point.y;
    increment_x(&mut point);  // ERROR: cannot borrow `point` as mutable because `point.y` is already borrowed
    *y_ref = 500;
}

fn main() {
    // Uncomment ONE function to see success or error:
    success_single_field_ref();
    // error_multiple_field_refs();
    // success_call_mut_no_refs();
    // error_call_mut_with_field_ref();
    // error_call_mut_with_other_field_ref();
}
