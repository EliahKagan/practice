// LeetCode #44 - Wildcard Matching
// https://leetcode.com/problems/wildcard-matching/
// By tabulation (bottom-up dynamic programming) and collapsing runs of stars.

bool isMatch(const char *const s, const char *const p)
{
    const int m = strlen(s);
    const int n = strlen(p);
    bool dp[m + 1][n + 1]; // Max size ~4 MiB given problem constraints.

    // The empty substring matches the empty subpattern.
    dp[m][n] = true;

    // The empty substring matches a nonempty subpattern iff it is all '*'s.
    for (int j = n - 1; j >= 0; --j)
        dp[m][j] = dp[m][j + 1] && p[j] == '*';

    for (int i = m - 1; i >= 0; --i) {
        // A nonempty substring doesn't match the empty subpattern.
        dp[i][n] = false;

        for (int j = n - 1; j >= 0; --j) {
            switch (p[j]) {
            case '*':
                if (p[j + 1] == '*') {
                    // Collapse consecutive stars.
                    dp[i][j] = dp[i][j + 1];
                } else {
                    // Match the pattern position 0 or more times.
                    dp[i][j] = dp[i + 1][j] || dp[i][j + 1];
                }
                break;

            case '?':
                // Try to skip over one character of string and pattern.
                dp[i][j] = dp[i + 1][j + 1];
                break;

            default:
                // Try to match and pass one character of string and pattern.
                dp[i][j] = s[i] == p[j] && dp[i + 1][j + 1];
            }
        }
    }

    return dp[0][0];
}
