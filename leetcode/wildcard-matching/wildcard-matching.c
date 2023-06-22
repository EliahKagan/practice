// LeetCode #44 - Wildcard Matching
// https://leetcode.com/problems/wildcard-matching/
// By pure backtracking.

bool isMatch(const char *s, const char* p)
{
    switch (*p) {
    case '\0':
        // An empty pattern only matches an empty string (end of the string).
        return !*s;

    case '*':
        // Match the pattern position zero or more times, trying longest first.
        return (*s && isMatch(s + 1, p)) || isMatch(s, p + 1);

    case '?':
        // Try to skip over one character of string and pattern.
        return *s && isMatch(s + 1, p + 1);

    default:
        // Try to match and advance past one character of string and pattern.
        return *s == *p && isMatch(s + 1, p + 1);
    }
}
