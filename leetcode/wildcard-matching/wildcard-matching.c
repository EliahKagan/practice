// LeetCode #44 - Wildcard Matching
// https://leetcode.com/problems/wildcard-matching/
// By pure backtracking (and collapsing consecutive stars for performance).

bool isMatch(const char *s, const char* p)
{
    switch (p[0]) {
    case '\0':
        // An empty pattern only matches an empty string (end of the string).
        return !s[0];

    case '*':
        if (p[1] == '*') {
            // Collapse consecutive stars to avoid catastrophic backtracking.
            return isMatch(s, p + 1);
        }

        // Match the pattern position zero or more times, trying longest first.
        return (s[0] && isMatch(s + 1, p)) || isMatch(s, p + 1);

    case '?':
        // Try to skip over one character of string and pattern.
        return s[0] && isMatch(s + 1, p + 1);

    default:
        // Try to match and advance past one character of string and pattern.
        return s[0] == p[0] && isMatch(s + 1, p + 1);
    }
}
