write about different approaches for weak pointers.

talk about how the generation approach needs a pool, and it\'s hard to
have those in fat pointers or require supplying them to dereference.
think about what sugar rust might offer here\...

talk about the global hash map approach, and how it makes it difficult
to send things over thread boundaries

talk about how we\'re doing the vector approach rather than the
generation approach. talk about how you can actually think of it in
terms of a vector of strong refs, a bunch of links.
