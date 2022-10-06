Allows you to pass a mutable value safely to another thread without
locks!

Allows you to modify a mutable value without locks.

Allows you to safely read a mutable value without locks.

No dreaded \"java memory leak\"

foreign key constraints are good! they make things make sense. talk
about how DELETE paired with FOREIGN KEY kind of does what we\'re doing
here.

talk about the destructor case, how this system revealed that C++
destructors are kind of broken a little bit. 10/3 in discord

have faith. it will work. we made closures work! std::function didnt
have to be shared! we even made async/await work!

struct A { b: B; d: D; }

struct D {}

struct B { c: C; }

struct C { b: &D; }

c++ rules:

first we nuke D

then we nuke C, whose custom destructor might use D.

if there\'s no mutable aliases
