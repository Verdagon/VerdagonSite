talk about the benefit of thinking in references, and the freedom it
gives the optimizer. optimizer can look at if it\'s ever moved, ever
aliased, ever borrowed, ever modified, to do all sorts of cool
optimizations. and, if the user wants, he can force a certain way with
annotations.

talk about how we look at whether or not a variable is moved, and
intelligently inline.

talk about how the hammer attaches hints for midas so it can be more
performant in LLVM ("when hammer boxes things, perhaps provide a hint to
midas that its a tiny type and that it can inline it when it feeds to
llvm. like, struct { %Marine\* } instead of %MarineBox."). perhaps also
talk about how superstructures have firebase annotations?

talk about how we're coding superstructure functions not in SQL but in
better imperative language.

talk about how we want to be close to the metal for performance, but
also close to the human for understandability and velocity. java is more
human, rust is more machine.
