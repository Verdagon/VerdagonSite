Talk about how we had scrambles get into the templar, which would
evaluate types of all the elements and then unscramble them.

Talk about how we almost moved it into the parser, and the parser would
do a quick scan of all imported files to figure out which were marked
infix.

Talk about how by making them the lowest precedence, they're now simply
a way to join together multiple expressions, like comma in c++. this
meant we didn't have to scan other things.

(investigate how scala does things)
