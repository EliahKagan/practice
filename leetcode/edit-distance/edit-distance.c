// LeetCode #72 - Edit Distance
// https://leetcode.com/problems/edit-distance/
// By tabulation (bottom-up dynamic programming).

static inline int min(const int x, const int y)
{
    return y < x ? y : x;
}

int minDistance(const char *const s, const char *const t)
{
    const int m = strlen(s);
    const int n = strlen(t);
    int dp[m + 1][n + 1];

    for (int j = 0; j <= n; ++j)
        dp[0][j] = j;

    for (int i = 1; i <= m; ++i)
        dp[i][0] = i;

    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            // If we add or remove a letter.
            const int add_remove_distance = min(dp[i][j - 1] + 1,
                                                dp[i - 1][j] + 1);

            // Costs 0 to keep, 1 to change. ("- 1" for 0-based indexing.)
            const int letter_cost = s[i - 1] != t[j - 1];

            // If we change or keep a letter.
            const int change_keep_distance = dp[i - 1][j - 1] + letter_cost;

            dp[i][j] = min(add_remove_distance, change_keep_distance);
        }
    }

    return dp[m][n];
}
