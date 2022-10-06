talk about how rust forces you into designs like in
https://www.youtube.com/watch?v=aKLntZcp27M

talk about how thats part of the tradeoff in rust

talk about how V will influence you to a layered DAG approach (if it
does)

[[https://rust-leipzig.github.io/architecture/2016/12/20/idiomatic-trees-in-rust/]{.underline}](https://rust-leipzig.github.io/architecture/2016/12/20/idiomatic-trees-in-rust/)

[[https://youtu.be/4YTfxresvS8?t=822]{.underline}](https://youtu.be/4YTfxresvS8?t=822)

So, you can do this\... ive written a fair amount of code using this
model, but it is not fun, it is pretty painful. So you get a lot of
extra noise in the program, where you\'re constantly borrowing these
explicit references, the types get a lot of angle brackets in a row
which is not great to look at. And, it\'s also not fun at runtime,
because you need to borrow() in order to actually be able to do do
anything with these objects. And if your borrow is too long, and you do
something while you\'re still holding the borrow, then you get a panic,
or in the case of multithreaded programming, you get a\--ive kind of
written this in the single threaded case, and that\'s another problem,
it kind of forces you to choose, am i in a single threaded world or a
multi-threaded world\--in a multithreaded world you\'d get a deadlock,
which is also not a great experience.

so i think we want to look at alternatives. like, don\'t just write
object oriented code in rust, how else might you structure a system?

\[Re: using Rc/RefCell to get around borrow checked\] \"So, you can do
this\... ive written a fair amount of code using this model, but it is
not fun, it is pretty painful. So you get a lot of extra noise in the
program, where you\'re constantly borrowing these explicit references,
the types get a lot of angle brackets in a row which is not great to
look at. And, it\'s also not fun at runtime, because you need to
borrow() in order to actually be able to do do anything with these
objects. And if your borrow is too long, and you \[borrow_mut()\] while
you\'re still holding the borrow, then you get a panic. And in the case
of multithreaded programming, you get a deadlock, which is also not a
great experience. I\'ve kind of written this in the single threaded
case, and that\'s another problem, it kind of forces you to choose: am I
in a single threaded world or a multi-threaded world?\"

So i think we want to look at alternatives. like, don\'t just write
object oriented code in rust, how else might you structure a system?

\"that\'s really a theme\... that if youre trying to program object
oriented programming in rust, you will be fighting the borrow checker.
and in this kind of data-oriented world, you\'re not doing that.\"
