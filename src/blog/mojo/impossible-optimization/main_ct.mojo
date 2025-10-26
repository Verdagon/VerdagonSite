from regex_common import (
    MAX_NODES,
    MAX_OPTIONS,
    MAX_SEQUENCE_ITEMS,
    LiteralNode,
    CharClassNode,
    OrNode,
    RepeatNode,
    SequenceNode,
    RegexNode,
    Parser,
    MatchResult,
    Regex,
)
from benchmark import keep
from time import perf_counter_ns


@always_inline
fn _match_node[
    nodes: List[RegexNode], node_idx: Int
](text: String, start_pos: Int) -> MatchResult:
    alias node = nodes[node_idx]

    @parameter
    if node.isa[LiteralNode]():
        alias literal_node = node[LiteralNode]
        return _match_literal[nodes, literal_node](text, start_pos)
    elif node.isa[RepeatNode]():
        alias repeat_node = node[RepeatNode]
        return _match_repeat[nodes, repeat_node](text, start_pos)
    elif node.isa[CharClassNode]():
        alias charclass_node = node[CharClassNode]
        return _match_charclass[nodes, charclass_node](text, start_pos)
    elif node.isa[OrNode]():
        alias or_node = node[OrNode]
        return _match_or[nodes, or_node](text, start_pos)
    elif node.isa[SequenceNode]():
        alias sequence_node = node[SequenceNode]
        return _match_sequence[nodes, sequence_node](text, start_pos)

    return MatchResult(False, 0)


@always_inline
fn _match_literal[
    nodes: List[RegexNode], literal_node: LiteralNode  # Compile-time parameter!
](text: String, start_pos: Int) -> MatchResult:
    """Match a literal string with full compile-time specialization.

    The literal_node is passed as a compile-time parameter, allowing the
    compiler to generate optimized code for this specific literal.
    """
    alias literal = literal_node.string_literal
    var end_pos = start_pos + len(literal)

    if end_pos > len(text):
        return MatchResult(False, 0)

    # Could potentially unroll this loop too for small literals
    for i in range(len(literal)):
        if text[start_pos + i] != literal[i]:
            return MatchResult(False, 0)

    return MatchResult(True, len(literal))


@always_inline
fn _match_charclass[
    nodes: List[RegexNode],
    charclass_node: CharClassNode,  # Compile-time parameter!
](text: String, start_pos: Int) -> MatchResult:
    """Match a character class with full compile-time specialization.

    Supports:
    - "word": [a-zA-Z0-9_]
    - "digit": [0-9]
    - "space": [ \t\n\r]
    - "any": any character
    """
    if start_pos >= len(text):
        return MatchResult(False, 0)

    var ch = text[start_pos]
    alias char_class = charclass_node.char_class

    var matches = False

    if char_class == "any":
        matches = True
    elif char_class == "word":
        # Word character: a-z, A-Z, 0-9, or _
        matches = (
            (ord("a") <= ord(ch) <= ord("z"))
            or (ord("A") <= ord(ch) <= ord("Z"))
            or (ord("0") <= ord(ch) <= ord("9"))
            or ch == "_"
        )
    elif char_class == "digit":
        # Digit: 0-9
        matches = ord("0") <= ord(ch) <= ord("9")
    elif char_class == "space":
        # Whitespace: space, tab, newline, carriage return
        matches = ch == " " or ch == "\t" or ch == "\n" or ch == "\r"

    if matches:
        return MatchResult(True, 1)
    else:
        return MatchResult(False, 0)


@always_inline
fn _match_or[
    nodes: List[RegexNode], or_node: OrNode  # Compile-time parameter!
](text: String, start_pos: Int) -> MatchResult:
    """Match OR node with full compile-time specialization.

    Since or_node is a compile-time parameter, or_node.num_options is compile-time too,
    so we can use it directly in the range! The compiler generates exactly the right
    number of iterations - no extra bounds checks needed.
    """

    @parameter
    for i in range(or_node.num_options):
        var result = _match_node[nodes, or_node.options[i]](text, start_pos)
        if result.matched:
            return result^

    return MatchResult(False, 0)


@always_inline
fn _match_repeat[
    nodes: List[RegexNode], repeat_node: RepeatNode  # Compile-time parameter!
](text: String, start_pos: Int) -> MatchResult:
    """Match repetition node with compile-time specialization."""
    var matches = 0
    var total_consumed = 0
    var pos = start_pos

    # Note: This loop must remain runtime since we don't know how many matches until we try
    while True:
        if (
            repeat_node.maximum_times >= 0
            and matches >= repeat_node.maximum_times
        ):
            break

        var result = _match_node[nodes, repeat_node.repeated](text, pos)
        if not result.matched:
            break

        # Prevent infinite loop on zero-length matches
        if result.chars_consumed == 0:
            break

        matches += 1
        total_consumed += result.chars_consumed
        pos += result.chars_consumed

    # Check if we met the minimum requirement
    if matches >= repeat_node.minimum_times:
        return MatchResult(True, total_consumed)
    else:
        return MatchResult(False, 0)


@always_inline
fn _match_sequence[
    nodes: List[RegexNode],
    sequence_node: SequenceNode,  # Compile-time parameter!
](text: String, start_pos: Int) -> MatchResult:
    """Match sequence with full compile-time specialization.

    Since sequence_node is a compile-time parameter, sequence_node.num_items is compile-time too,
    so we can use it directly in the range! The compiler generates exactly the right
    number of iterations - no extra bounds checks needed.
    """
    var total_consumed = 0
    var pos = start_pos

    @parameter
    for i in range(sequence_node.num_items):
        var result = _match_node[nodes, sequence_node.items[i]](text, pos)
        if not result.matched:
            return MatchResult(False, 0)

        total_consumed += result.chars_consumed
        pos += result.chars_consumed

    return MatchResult(True, total_consumed)


@no_inline
fn matches[regex: Regex](text: String) -> Bool:
    """Check if regex matches text (compile-time optimized version).

    Takes regex as a compile-time parameter, enabling aggressive optimizations.
    The entire regex structure is known at compile-time, allowing the compiler
    to generate specialized matching code.

    Parameters:
        regex: The compiled regex pattern (compile-time constant).

    Args:
        text: The text to match against.

    Returns:
        True if the entire text matches the pattern, False otherwise.
    """
    var result = _match_node[regex.nodes, regex.root_idx](text, 0)
    return result.matched and result.chars_consumed == len(text)


fn main():
    alias email_regex = Regex(
        "\\w+(\\+\\w*)?@(\\d+\\.\\d+\\.\\d+\\.\\d+|\\w+\\.\\w+)"
    )
    alias NUM_SUBJECTS = 8
    var subjects = InlineArray[String, NUM_SUBJECTS](
        "user@example.com",  # yes
        "uexample.com",  # no
        "user@ecom",  # no
        "user+tag@example.com",  # yes
        "user@100",  # no
        "howdy123@1.2.3.4",  # yes
        "howdy1231.2.3.4",  # no
        "howdy123@1/2/3/4",  # no
    )

    debug_assert[assert_mode="safe"](
        matches[email_regex](subjects[0]), "failed 0"
    )
    debug_assert[assert_mode="safe"](
        not matches[email_regex](subjects[1]), "failed 1"
    )
    debug_assert[assert_mode="safe"](
        not matches[email_regex](subjects[2]), "failed 2"
    )
    debug_assert[assert_mode="safe"](
        matches[email_regex](subjects[3]), "failed 3"
    )
    debug_assert[assert_mode="safe"](
        not matches[email_regex](subjects[4]), "failed 4"
    )
    debug_assert[assert_mode="safe"](
        matches[email_regex](subjects[5]), "failed 5"
    )
    debug_assert[assert_mode="safe"](
        not matches[email_regex](subjects[6]), "failed 6"
    )
    debug_assert[assert_mode="safe"](
        not matches[email_regex](subjects[7]), "failed 7"
    )

    var start = perf_counter_ns()

    for i in range(0, 200_000_000):
        keep(matches[email_regex](subjects[i % 8]))

    var end = perf_counter_ns()
    var elapsed_ns = end - start
    var elapsed_ms = Float64(elapsed_ns) / 1_000_000.0

    print("Elapsed time: ", elapsed_ns, " ns (", elapsed_ms, " ms)")
