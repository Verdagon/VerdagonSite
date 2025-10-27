"""Hand-written inlined version of the regex matcher.

This shows what the compiler would generate after fully inlining all the
compile-time specialized functions for the pattern:
    \\w+(\\+\\w*)?@(\\d+\\.\\d+\\.\\d+\\.\\d+|\\w+\\.\\w+)

This is a single flat function with no recursion, no function calls,
and all the pattern-matching logic specialized for this exact regex.
It's as if you wrote the matcher by hand without any regex involved.
"""

from benchmark import keep
from time import perf_counter_ns


@no_inline
fn matches(text: String) -> Bool:
    var total_consumed = 0
    var pos = 0
    var text_len = len(text)
    var word_matches = 0
    var word_total_consumed = 0
    while True:
        if pos >= text_len:
            break
        var ch = text[pos]
        alias char_class = "word"
        var char_matches = False
        char_matches = (
            (ord("a") <= ord(ch) <= ord("z"))
            or (ord("A") <= ord(ch) <= ord("Z"))
            or (ord("0") <= ord(ch) <= ord("9"))
            or ch == "_"
        )
        if not char_matches:
            break
        var chars_consumed = 1
        if chars_consumed == 0:
            break
        word_matches += 1
        word_total_consumed += chars_consumed
        pos += chars_consumed
    if word_matches < 1:
        return False
    total_consumed += word_total_consumed
    var optional_matches = 0
    var optional_total_consumed = 0
    var optional_pos = pos
    while True:
        if optional_matches >= 1:
            break
        var seq_total_consumed = 0
        var seq_pos = optional_pos
        var seq_matched = True
        alias plus_lit = String("+")
        var plus_end_pos = seq_pos + len(plus_lit)
        if plus_end_pos > text_len:
            seq_matched = False
        elif text[seq_pos + 0] != plus_lit[0]:
            seq_matched = False
        else:
            seq_total_consumed += len(plus_lit)
            seq_pos += len(plus_lit)
        if seq_matched:
            var inner_matches = 0
            var inner_total_consumed = 0
            while True:
                if seq_pos >= text_len:
                    break
                var ch2 = text[seq_pos]
                alias char_class2 = "word"
                var char_matches2 = False
                char_matches2 = (
                    (ord("a") <= ord(ch2) <= ord("z"))
                    or (ord("A") <= ord(ch2) <= ord("Z"))
                    or (ord("0") <= ord(ch2) <= ord("9"))
                    or ch2 == "_"
                )
                if not char_matches2:
                    break
                var chars_consumed2 = 1
                if chars_consumed2 == 0:
                    break
                inner_matches += 1
                inner_total_consumed += chars_consumed2
                seq_pos += chars_consumed2
            seq_total_consumed += inner_total_consumed
        if not seq_matched:
            break
        if seq_total_consumed == 0:
            break
        optional_matches += 1
        optional_total_consumed += seq_total_consumed
        optional_pos += seq_total_consumed
    pos = optional_pos
    total_consumed += optional_total_consumed
    alias at_lit = String("@")
    var at_end_pos = pos + len(at_lit)
    if at_end_pos > text_len:
        return False
    if text[pos + 0] != at_lit[0]:
        return False
    pos += len(at_lit)
    total_consumed += len(at_lit)
    var or_start_pos = pos
    var or_matched = False
    var digit_matches = 0
    var digit_total_consumed = 0
    while True:
        if pos >= text_len:
            break
        var ch_digit = text[pos]
        alias char_class_digit = "digit"
        var digit_char_matches = False
        digit_char_matches = ord("0") <= ord(ch_digit) <= ord("9")
        if not digit_char_matches:
            break
        var digit_chars_consumed = 1
        if digit_chars_consumed == 0:
            break
        digit_matches += 1
        digit_total_consumed += digit_chars_consumed
        pos += digit_chars_consumed
    if digit_matches >= 1:
        alias dot_lit = String(".")
        var dot_end_pos = pos + len(dot_lit)
        if dot_end_pos > text_len:
            pass
        elif text[pos + 0] != dot_lit[0]:
            pass
        else:
            pos += len(dot_lit)
            digit_matches = 0
            digit_total_consumed = 0
            while True:
                if pos >= text_len:
                    break
                var ch_digit2 = text[pos]
                alias char_class_digit2 = "digit"
                var digit_char_matches2 = False
                digit_char_matches2 = ord("0") <= ord(ch_digit2) <= ord("9")
                if not digit_char_matches2:
                    break
                var digit_chars_consumed2 = 1
                if digit_chars_consumed2 == 0:
                    break
                digit_matches += 1
                digit_total_consumed += digit_chars_consumed2
                pos += digit_chars_consumed2
            if digit_matches >= 1:
                var dot_end_pos2 = pos + len(dot_lit)
                if dot_end_pos2 > text_len:
                    pass
                elif text[pos + 0] != dot_lit[0]:
                    pass
                else:
                    pos += len(dot_lit)
                    digit_matches = 0
                    digit_total_consumed = 0
                    while True:
                        if pos >= text_len:
                            break
                        var ch_digit3 = text[pos]
                        alias char_class_digit3 = "digit"
                        var digit_char_matches3 = False
                        digit_char_matches3 = ord("0") <= ord(ch_digit3) <= ord("9")
                        if not digit_char_matches3:
                            break
                        var digit_chars_consumed3 = 1
                        if digit_chars_consumed3 == 0:
                            break
                        digit_matches += 1
                        digit_total_consumed += digit_chars_consumed3
                        pos += digit_chars_consumed3
                    if digit_matches >= 1:
                        var dot_end_pos3 = pos + len(dot_lit)
                        if dot_end_pos3 > text_len:
                            pass
                        elif text[pos + 0] != dot_lit[0]:
                            pass
                        else:
                            pos += len(dot_lit)
                            digit_matches = 0
                            digit_total_consumed = 0
                            while True:
                                if pos >= text_len:
                                    break
                                var ch_digit4 = text[pos]
                                alias char_class_digit4 = "digit"
                                var digit_char_matches4 = False
                                digit_char_matches4 = ord("0") <= ord(ch_digit4) <= ord("9")
                                if not digit_char_matches4:
                                    break
                                var digit_chars_consumed4 = 1
                                if digit_chars_consumed4 == 0:
                                    break
                                digit_matches += 1
                                digit_total_consumed += digit_chars_consumed4
                                pos += digit_chars_consumed4
                            if digit_matches >= 1:
                                or_matched = True
    if not or_matched:
        pos = or_start_pos
        var word_matches_b = 0
        var word_total_consumed_b = 0
        while True:
            if pos >= text_len:
                break
            var ch_word_b = text[pos]
            alias char_class_word_b = "word"
            var word_char_matches_b = False
            word_char_matches_b = (
                (ord("a") <= ord(ch_word_b) <= ord("z"))
                or (ord("A") <= ord(ch_word_b) <= ord("Z"))
                or (ord("0") <= ord(ch_word_b) <= ord("9"))
                or ch_word_b == "_"
            )
            if not word_char_matches_b:
                break
            var word_chars_consumed_b = 1
            if word_chars_consumed_b == 0:
                break
            word_matches_b += 1
            word_total_consumed_b += word_chars_consumed_b
            pos += word_chars_consumed_b
        if word_matches_b < 1:
            return False
        alias dot_lit2 = String(".")
        var dot_end_pos_b = pos + len(dot_lit2)
        if dot_end_pos_b > text_len:
            return False
        if text[pos + 0] != dot_lit2[0]:
            return False
        pos += len(dot_lit2)
        var word_matches_b2 = 0
        var word_total_consumed_b2 = 0
        while True:
            if pos >= text_len:
                break
            var ch_word_b2 = text[pos]
            alias char_class_word_b2 = "word"
            var word_char_matches_b2 = False
            word_char_matches_b2 = (
                (ord("a") <= ord(ch_word_b2) <= ord("z"))
                or (ord("A") <= ord(ch_word_b2) <= ord("Z"))
                or (ord("0") <= ord(ch_word_b2) <= ord("9"))
                or ch_word_b2 == "_"
            )
            if not word_char_matches_b2:
                break
            var word_chars_consumed_b2 = 1
            if word_chars_consumed_b2 == 0:
                break
            word_matches_b2 += 1
            word_total_consumed_b2 += word_chars_consumed_b2
            pos += word_chars_consumed_b2
        if word_matches_b2 < 1:
            return False
    return pos == text_len


fn main():
    """Test the hand-written matcher with the same test cases."""
    alias NUM_SUBJECTS = 8
    var subjects = InlineArray[String, NUM_SUBJECTS](
        "user@example.com",       # yes - matches \\w+@\\w+\\.\\w+
        "uexample.com",           # no  - missing @
        "user@ecom",              # no  - missing dot in domain
        "user+tag@example.com",   # yes - matches \\w+\\+\\w+@\\w+\\.\\w+
        "user@100",               # no  - missing dots for IP, not enough dots for domain
        "howdy123@1.2.3.4",       # yes - matches \\w+@\\d+\\.\\d+\\.\\d+\\.\\d+
        "howdy1231.2.3.4",        # no  - missing @
        "howdy123@1/2/3/4",       # no  - slashes instead of dots
    )

    # Run assertions
    debug_assert[assert_mode="safe"](matches(subjects[0]), "failed 0")
    debug_assert[assert_mode="safe"](not matches(subjects[1]), "failed 1")
    debug_assert[assert_mode="safe"](not matches(subjects[2]), "failed 2")
    debug_assert[assert_mode="safe"](matches(subjects[3]), "failed 3")
    debug_assert[assert_mode="safe"](not matches(subjects[4]), "failed 4")
    debug_assert[assert_mode="safe"](matches(subjects[5]), "failed 5")
    debug_assert[assert_mode="safe"](not matches(subjects[6]), "failed 6")
    debug_assert[assert_mode="safe"](not matches(subjects[7]), "failed 7")

    # Benchmark
    var start = perf_counter_ns()

    for i in range(0, 200_000_000):
        keep(matches(subjects[i % 8]))

    var end = perf_counter_ns()
    var elapsed_ns = end - start
    var elapsed_ms = Float64(elapsed_ns) / 1_000_000.0

    print("Elapsed time: ", elapsed_ns, " ns (", elapsed_ms, " ms)")
