talk about how pools for each struct give us memory safety cuz
use-after-free on a reused obj of same type is safe

talk it up like its the next huge thing

talk about how its main weakness of bloat and fragmentation is solved by
region calling

compare it to rust and c++ and vectors and reusing elements in a vec

say how it cut away N% of our ref counts in our program. talk about the
speedup from no malloc

talk about the cost of copying out. maybe mention garbage collectors
that do this.

talk about how the inl keyword makes this possible, because we can toss
unions yonder
