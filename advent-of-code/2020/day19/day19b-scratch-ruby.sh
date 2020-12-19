#!/bin/sh

# This tries out the Ruby \g<-1> syntax, which I think has the same effect as
# the Perl and PCRE2* (?-1) syntax.
#
# See: https://www.regular-expressions.info/subroutine.html
#
# * PCRE has this as well but recursion (including "subroutine calls") is
#   atomic. See the comments in day19b-scratch-backtracking.sh.

ruby -nwe 'puts $_ if $_ =~ /^((?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)|(?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)\g<-1>)((?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)(?:b(?:b(?:aba|baa)|a(?:b(?:ab|(?:a|b)a)|a(?:ba|ab)))|a(?:b(?:(?:ab|(?:a|b)a)b|(?:(?:a|b)a|bb)a)|a(?:bab|(?:ba|bb)a)))|(?:(?:b(?:a(?:bb|ab)|b(?:a|b)(?:a|b))|a(?:bbb|a(?:bb|a(?:a|b))))b|(?:(?:(?:aa|ab)a|bbb)b|(?:(?:a|b)a|bb)aa)a)\g<-1>(?:b(?:b(?:aba|baa)|a(?:b(?:ab|(?:a|b)a)|a(?:ba|ab)))|a(?:b(?:(?:ab|(?:a|b)a)b|(?:(?:a|b)a|bb)a)|a(?:bab|(?:ba|bb)a))))$/' example-b | diff example-b-matches -
