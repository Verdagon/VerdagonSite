@fieldwise_init
struct Wing(Copyable, Movable):
    var span: Int

@fieldwise_init
struct Tail(Copyable, Movable):
    var length: Int

@fieldwise_init
struct Bird:
    var left: Wing
    var right: Wing
    var tail: Tail

    fn get_weight(self) -> Int:
        return self.left.span + self.right.span + self.tail.length

# fn main():
#     var bird = Bird(Wing(10), Wing(20), Tail(15))
#     ref tail_ref = bird.tail
#     tail_ref.length += bird.get_weight()


fn main():
    var bird = Bird(Wing(10), Wing(20), Tail(15))
    ref tail_ref = bird.tail
    evolve(bird, tail_ref)


fn evolve(bird: Bird, mut tail_ref: Tail):
    tail_ref.length += bird.get_weight()
