from regex_common import (
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


fn _match_node(
    nodes: List[RegexNode], node_idx: Int, text: String, start_pos: Int
) -> MatchResult:
    var node = nodes[node_idx]
    if node.isa[LiteralNode]():
        ref literal_node = node[LiteralNode]
        return _match_literal(nodes, literal_node, text, start_pos)
    elif node.isa[RepeatNode]():
        ref repeat_node = node[RepeatNode]
        return _match_repeat(nodes, repeat_node, text, start_pos)
    elif node.isa[CharClassNode]():
        ref charclass_node = node[CharClassNode]
        return _match_charclass(nodes, charclass_node, text, start_pos)
    elif node.isa[OrNode]():
        ref or_node = node[OrNode]
        return _match_or(nodes, or_node, text, start_pos)
    elif node.isa[SequenceNode]():
        ref sequence_node = node[SequenceNode]
        return _match_sequence(nodes, sequence_node, text, start_pos)
    else:
        return MatchResult(False, 0)


fn _match_literal(
    nodes: List[RegexNode], node: LiteralNode, text: String, start_pos: Int
) -> MatchResult:
    """Internal function to match a literal string."""
    var literal = node.string_literal
    var end_pos = start_pos + len(literal)

    if end_pos > len(text):
        return MatchResult(False, 0)

    # Check if the substring matches
    for i in range(len(literal)):
        if text[start_pos + i] != literal[i]:
            return MatchResult(False, 0)

    return MatchResult(True, len(literal))


fn _match_charclass(
    nodes: List[RegexNode], node: CharClassNode, text: String, start_pos: Int
) -> MatchResult:
    """Internal function to match a character class.

    Supports:
    - "word": [a-zA-Z0-9_]
    - "digit": [0-9]
    - "space": [ \t\n\r]
    - "any": any character
    """
    if start_pos >= len(text):
        return MatchResult(False, 0)

    var ch = text[start_pos]
    var char_class = node.char_class

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


fn _match_or(
    nodes: List[RegexNode], node: OrNode, text: String, start_pos: Int
) -> MatchResult:
    """Internal function to match an alternation (OR) node (runtime version)."""
    # Try each option in the OR
    for i in range(node.num_options):
        var result = _match_node(nodes, node.options[i], text, start_pos)
        if result.matched:
            return result^

    return MatchResult(False, 0)


fn _match_repeat(
    nodes: List[RegexNode], node: RepeatNode, text: String, start_pos: Int
) -> MatchResult:
    var matches = 0
    var total_consumed = 0
    var pos = start_pos
    while True:
        if node.maximum_times >= 0 and matches >= node.maximum_times:
            break
        var result = _match_node(nodes, node.repeated, text, pos)
        if not result.matched:
            break
        if result.chars_consumed == 0:
            break
        matches += 1
        total_consumed += result.chars_consumed
        pos += result.chars_consumed
    if matches >= node.minimum_times:
        return MatchResult(True, total_consumed)
    else:
        return MatchResult(False, 0)


fn _match_sequence(
    nodes: List[RegexNode], node: SequenceNode, text: String, start_pos: Int
) -> MatchResult:
    """Internal function to match a sequence of nodes (runtime version)."""
    var total_consumed = 0
    var pos = start_pos

    # Match each item in sequence
    for i in range(node.num_items):
        var result = _match_node(nodes, node.items[i], text, pos)
        if not result.matched:
            return MatchResult(False, 0)

        total_consumed += result.chars_consumed
        pos += result.chars_consumed

    return MatchResult(True, total_consumed)


@no_inline
fn matches(regex: Regex, text: String) -> Bool:
    """Check if the regex matches the entire text string (runtime version).

    Args:
        regex: The compiled regex pattern.
        text: The text to match against.

    Returns:
        True if the entire text matches the pattern, False otherwise.
    """
    var result = _match_node(regex.nodes, regex.root_idx, text, 0)
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
    debug_assert(matches(email_regex, subjects[0]))
    debug_assert(not matches(email_regex, subjects[1]))
    debug_assert(not matches(email_regex, subjects[2]))
    debug_assert(matches(email_regex, subjects[3]))
    debug_assert(not matches(email_regex, subjects[4]))
    debug_assert(matches(email_regex, subjects[5]))
    debug_assert(not matches(email_regex, subjects[6]))
    debug_assert(not matches(email_regex, subjects[7]))

    var start = perf_counter_ns()

    for i in range(0, 200_000_000):
        keep(matches(email_regex, subjects[i % 8]))

        # Test complex pattern with all features
        # alias regexA = Regex("(hello|howdy) (and greetings )?my name is \\w+!*")
        # keep(matches(regexA, "hello my name is Bob"))
        # keep(matches(regexA, "howdy my name is Alice"))
        # keep(matches(regexA, "hello and greetings my name is Carol"))
        # keep(matches(regexA, "howdy and greetings my name is Dave!!!"))
        # keep(not matches(regexA, "hi my name is Eve"))
        # keep(not matches(regexA, "hello my name is"))
        # keep(matches(regexA, "hello and greetings my name is spork"))

    var end = perf_counter_ns()
    var elapsed_ns = end - start
    var elapsed_ms = Float64(elapsed_ns) / 1_000_000.0

    print("Elapsed time: ", elapsed_ns, " ns (", elapsed_ms, " ms)")
