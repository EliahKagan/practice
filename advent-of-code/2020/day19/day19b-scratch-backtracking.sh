#!/bin/sh

# The problem appears to be that Crystal uses PCRE1, not PCRE2. This means that
# while Crystal (unlike Ruby) does support the (?-1) syntax [not just (?R)],
# backtracking doesn't retry other recursion depths than the one chosen for the
# submatch (i.e., recursive groups are atomic). In Perl it appears to work, and
# I would expect it to work with PCRE2 as well since, in my usage, all
# recursion appears inside capturing groups.
#
# See: https://www.regular-expressions.info/recursebacktrack.html

perl -nwe 'print if /^((?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)|(?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)(?-1))((?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)(?:b(?:b(?:aba|baa)|a(?:b(?:ab|(?:a|b)a)|a(?:ba|ab)))|a(?:b(?:(?:ab|(?:a|b)a)b|(?:(?:a|b)a|bb)a)|a(?:bab|(?:ba|bb)a)))|(?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)(?-1)(?:b(?:b(?:aba|baa)|a(?:b(?:ab|(?:a|b)a)|a(?:ba|ab)))|a(?:b(?:(?:ab|(?:a|b)a)b|(?:(?:a|b)a|bb)a)|a(?:bab|(?:ba|bb)a))))$/' example-b | diff example-b-matches -
