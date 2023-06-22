// LeetCode #44 - Wildcard Matching
// https://leetcode.com/problems/wildcard-matching/
// By memoization (top-down dynamic programming) and collapsing runs of stars.

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr && num != 0 && size != 0) abort();
    return ptr;
}

enum state { k_unknown, k_no_match, k_match };

static enum state **create_memo(const int m, const int n)
{
    enum state **const memo = xcalloc(m + 1, sizeof(memo[0]));

    for (int i = 0; i <= m; ++i) {
        memo[i] = xcalloc(n + 1, sizeof(memo[i][0]));
    }

    return memo;
}

static void destroy_memo(enum state **const memo, const int m)
{
    for (int i = 0; i <= m; ++i) {
        free(memo[i]);
    }

    free(memo);
}

static bool matches_at(enum state **const memo,
                       const char *const s, const char *const p,
                       const int i, const int j)
{
    switch (memo[i][j]) {
    case k_unknown:
        break;
    case k_no_match:
        return false;
    case k_match:
        return true;
    }

    bool result = false; // This will be assigned below.

    switch (p[j]) {
    case '\0':
        // An empty pattern only matches an empty string (end of the string).
        result = s[i] == '\0';
        break;

    case '*':
        if (p[j + 1] == '*') {
            // Collapse consecutive stars.
            result = matches_at(memo, s, p, i, j + 1);
        } else {
            // Match the pattern position 0 or more times (longest first).
            result = (s[i] != '\0' && matches_at(memo, s, p, i + 1, j))
                     || matches_at(memo, s, p, i, j + 1);
        }
        break;

    case '?':
        // Try to skip over one character of string and pattern.
        result = s[i] != '\0' && matches_at(memo, s, p, i + 1, j + 1);
        break;

    default:
        // Try to match and advance past one character of string and pattern.
        result = s[i] == p[j] && matches_at(memo, s, p, i + 1, j + 1);
    }

    memo[i][j] = (result ? k_match : k_no_match);
    return result;
}

bool isMatch(const char *const s, const char *const p)
{
    const int m = strlen(s);
    const int n = strlen(p);
    enum state **const memo = create_memo(m, n);
    const bool result = matches_at(memo, s, p, 0, 0);
    destroy_memo(memo, m);
    return result;
}
