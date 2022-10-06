write a blog on how special treatment of \'this\' was a mistake. find a
bunch of examples, including how std::function is such a nightmare, c++
method pointers suck, js\'s bind\...

in our rules, we can have:

exists(fn call(#H, #K)Int)

instead of:

has_method(#H, fn call(#K)Int)
