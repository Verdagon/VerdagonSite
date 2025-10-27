"""Common regex data structures and parser.

This module contains the shared code between compile-time and runtime regex implementations:
- Node type definitions
- Parser implementation
- Regex struct
"""

from utils import Variant, StaticTuple
from os import abort
from collections import InlineArray

alias MAX_NODES = 100
alias MAX_OPTIONS = 20  # Max branches in an OR node
alias MAX_SEQUENCE_ITEMS = 20  # Max items in a sequence


@fieldwise_init
struct LiteralNode(ImplicitlyCopyable, Movable):
    var string_literal: String


@fieldwise_init
struct CharClassNode(ImplicitlyCopyable, Movable):
    var char_class: String  # "word", "digit", "any", etc.


@fieldwise_init
struct OrNode(ImplicitlyCopyable, Movable):
    var options: StaticTuple[Int, MAX_OPTIONS]
    var num_options: Int


@fieldwise_init
struct RepeatNode(ImplicitlyCopyable, Movable):
    var repeated: Int  # index into the node list
    var minimum_times: Int
    var maximum_times: Int  # -1 means unlimited


@fieldwise_init
struct SequenceNode(ImplicitlyCopyable, Movable):
    var items: StaticTuple[Int, MAX_SEQUENCE_ITEMS]
    var num_items: Int


alias RegexNode = Variant[
    LiteralNode,
    OrNode,
    RepeatNode,
    SequenceNode,
    CharClassNode,
]


struct Parser(Movable):
    var pattern: String
    var pos: Int
    var nodes: List[RegexNode]

    fn __init__(out self, pattern: String):
        self.pattern = pattern
        self.pos = 0
        self.nodes = List[RegexNode]()

    fn __moveinit__(out self, deinit existing: Self):
        self.pattern = existing.pattern^
        self.pos = existing.pos
        self.nodes = existing.nodes^

    fn peek(self) -> String:
        if self.pos >= len(self.pattern):
            return ""
        return String(self.pattern[self.pos])

    fn advance(mut self) -> String:
        var ch = self.peek()
        self.pos += 1
        return ch

    fn parse(mut self) raises -> Int:
        return self.parse_or()

    fn parse_or(mut self) raises -> Int:
        var options = List[Int]()
        options.append(self.parse_sequence())

        while self.peek() == "|":
            _ = self.advance()  # consume '|'
            options.append(self.parse_sequence())

        if len(options) == 1:
            return options[0]
        else:
            if len(options) > MAX_OPTIONS:
                raise Error(
                    "Too many OR branches: maximum is " + String(MAX_OPTIONS)
                )

            var static_options = StaticTuple[Int, MAX_OPTIONS]()
            for i in range(len(options)):
                static_options[i] = options[i]

            var node = OrNode(static_options, len(options))
            self.nodes.append(node^)
            return len(self.nodes) - 1

    fn parse_sequence(mut self) raises -> Int:
        var items = List[Int]()

        # Parse multiple items in sequence until we hit | or ) or end
        while True:
            var ch = self.peek()
            if ch == "" or ch == "|" or ch == ")":
                break
            items.append(self.parse_repeat())

        if len(items) == 0:
            raise Error("Expected at least one item in sequence")
        elif len(items) == 1:
            return items[0]
        else:
            if len(items) > MAX_SEQUENCE_ITEMS:
                raise Error(
                    "Sequence too long: maximum is "
                    + String(MAX_SEQUENCE_ITEMS)
                )

            var static_items = StaticTuple[Int, MAX_SEQUENCE_ITEMS]()
            for i in range(len(items)):
                static_items[i] = items[i]

            var node = SequenceNode(static_items, len(items))
            self.nodes.append(node^)
            return len(self.nodes) - 1

    fn parse_repeat(mut self) raises -> Int:
        var base = self.parse_primary()

        var ch = self.peek()
        if ch == "*":
            _ = self.advance()
            var node = RepeatNode(base, 0, -1)
            self.nodes.append(node^)
            return len(self.nodes) - 1
        elif ch == "+":
            _ = self.advance()
            var node = RepeatNode(base, 1, -1)
            self.nodes.append(node^)
            return len(self.nodes) - 1
        elif ch == "?":
            _ = self.advance()
            var node = RepeatNode(base, 0, 1)
            self.nodes.append(node^)
            return len(self.nodes) - 1
        else:
            return base

    fn parse_primary(mut self) raises -> Int:
        var ch = self.peek()

        if ch == "(":
            _ = self.advance()  # consume '('
            var node_idx = self.parse_or()
            if self.peek() != ")":
                raise Error("Expected closing parenthesis")
            _ = self.advance()  # consume ')'
            return node_idx
        elif ch == ".":
            # Any character
            _ = self.advance()
            var node = CharClassNode("any")
            self.nodes.append(node^)
            return len(self.nodes) - 1
        elif ch == "\\":
            # Escape sequence
            _ = self.advance()  # consume '\'
            var escaped = self.peek()
            if escaped == "":
                raise Error("Incomplete escape sequence")
            _ = self.advance()  # consume the escaped char

            if escaped == "w":
                # Word character: [a-zA-Z0-9_]
                var node = CharClassNode("word")
                self.nodes.append(node^)
                return len(self.nodes) - 1
            elif escaped == "d":
                # Digit character: [0-9]
                var node = CharClassNode("digit")
                self.nodes.append(node^)
                return len(self.nodes) - 1
            elif escaped == "s":
                # Whitespace character: [ \t\n\r]
                var node = CharClassNode("space")
                self.nodes.append(node^)
                return len(self.nodes) - 1
            else:
                # Literal escaped character (e.g., \*, \., \()
                var node = LiteralNode(escaped)
                self.nodes.append(node^)
                return len(self.nodes) - 1
        else:
            # Parse literal characters, but stop before a repeat operator
            # so that repeats apply only to single characters
            var literal = String()

            # Parse first character
            ch = self.peek()
            if (
                ch == ""
                or ch == "|"
                or ch == ")"
                or ch == "*"
                or ch == "+"
                or ch == "?"
                or ch == "("
                or ch == "\\"
                or ch == "."
            ):
                raise Error("Expected a literal character or group")

            literal += self.advance()

            # Check if next character is a repeat operator
            # If so, stop here so the repeat applies to just this one character
            var next_ch = self.peek()
            if next_ch == "*" or next_ch == "+" or next_ch == "?":
                # Return single character before repeat operator
                var node = LiteralNode(literal)
                self.nodes.append(node^)
                return len(self.nodes) - 1

            # Continue consuming literal characters, but check before each one
            # if the NEXT character would be followed by a repeat operator
            while True:
                ch = self.peek()
                # Stop at special characters
                if (
                    ch == ""
                    or ch == "|"
                    or ch == ")"
                    or ch == "*"
                    or ch == "+"
                    or ch == "?"
                    or ch == "("
                    or ch == "\\"
                    or ch == "."
                ):
                    break

                # Before consuming this character, check if the character AFTER it
                # is a repeat operator. If so, stop here so the next parse_primary
                # call will get that character followed by its repeat operator.
                if self.pos + 1 < len(self.pattern):
                    var char_after = self.pattern[self.pos + 1]
                    if (
                        char_after == "*"
                        or char_after == "+"
                        or char_after == "?"
                    ):
                        # Don't consume this character - leave it for next parse
                        break

                literal += self.advance()

            var node = LiteralNode(literal)
            self.nodes.append(node^)
            return len(self.nodes) - 1


struct MatchResult(Copyable, Movable):
    var matched: Bool
    var chars_consumed: Int

    @always_inline
    fn __init__(out self, matched: Bool, chars_consumed: Int):
        self.matched = matched
        self.chars_consumed = chars_consumed

struct Regex(ImplicitlyCopyable):
    var nodes: List[RegexNode]
    var root_idx: Int

    fn __init__(out self, pattern: String):
        # Initialize with defaults first (needed because abort doesn't return)
        self.nodes = List[RegexNode]()
        self.root_idx = 0

        var parser = Parser(pattern)
        try:
            var root = parser.parse()
            # Extract the nodes from the parser
            self.root_idx = root
            self.nodes = Self._extract_nodes(parser^)
        except e:
            abort(
                "Failed to parse regex pattern '" + pattern + "': " + String(e)
            )

    fn __copyinit__(out self, existing: Self):
        """Copy constructor - deep copy the nodes list.

        Required for ImplicitlyCopyable, which is needed for compile-time parameters.
        """
        self.nodes = List[RegexNode]()
        for i in range(len(existing.nodes)):
            self.nodes.append(existing.nodes[i])
        self.root_idx = existing.root_idx

    @staticmethod
    fn _extract_nodes(deinit parser: Parser) -> List[RegexNode]:
        return parser.nodes^

    fn __moveinit__(out self, deinit existing: Self):
        self.nodes = existing.nodes^
        self.root_idx = existing.root_idx

    @staticmethod
    fn _from_parser(deinit parser: Parser, root_idx: Int) -> Self:
        var regex = Self.__new__()
        regex.nodes = Self._extract_nodes(parser^)
        regex.root_idx = root_idx
        return regex
