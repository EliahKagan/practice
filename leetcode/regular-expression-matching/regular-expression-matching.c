// LeetCode #10 - Regular Expression Matching
// https://leetcode.com/problems/regular-expression-matching/
// By pure backtracking.

static inline bool char_match(const char sc, const char pc)
{
    return sc && (pc == '.' || pc == sc);
}

bool isMatch(const char *const s, const char *const p)
{
    if (!p[0]) {
        // An empty pattern only matches an empty string (end of the string).
        return !s[0];
    }

    assert(p[0] != '*'); // A valid subpattern never begin with a star.

    if (p[1] != '*') {
        // Try to advance the string and pattern by a single position.
        return char_match(s[0], p[0]) && isMatch(s + 1, p + 1);
    }

    // Match the pattern position zero or more times, trying longest first.
    return (char_match(s[0], p[0]) && isMatch(s + 1, p)) || isMatch(s, p + 2);
}
