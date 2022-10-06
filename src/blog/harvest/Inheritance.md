Inheritance is basically three things: composition, implements, and
forwarding. C++ and Java offer these three things together in one
package, plus they offer composition alone, and implements alone.

Show some examples of where inheritance is overkill and damaging.

Rust only offers composition alone and implements alone (sort of; can do
implementation inheritance via traits).

V will offer composition alone, implements alone, and forwarding alone.
To do inheritance, you must opt in to all three of these. This means
that you don\'t accidentally use a counterproductive stick of dynamite
where a nice hammer is needed.
