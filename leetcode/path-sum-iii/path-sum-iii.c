// LeetCode #437 - Path Sum III
// https://leetcode.com/problems/path-sum-iii/

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

static int dfs(const struct TreeNode *const root, int subtotal, const int total)
{
    if (!root) return 0;

    printf("%d %d\n", subtotal, total);

    subtotal += root->val;

    return (subtotal == total ? 1 : 0)
            + dfs(root->left, subtotal, total)
            + dfs(root->left, 0, total)
            + dfs(root->right, subtotal, total)
            + dfs(root->right, 0, total);
}

int pathSum(const struct TreeNode *const root, int targetSum)
{
    return dfs(root, 0, targetSum);
}
