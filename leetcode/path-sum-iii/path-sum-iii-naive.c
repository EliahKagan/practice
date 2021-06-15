// LeetCode #437 - Path Sum III
// https://leetcode.com/problems/path-sum-iii/
// Naive recursive solution with helper function. Runs in quadratic time.

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     struct TreeNode *left;
 *     struct TreeNode *right;
 * };
 */

static int dfs(const struct TreeNode *const root, int target)
{
    if (!root) return 0;

    target -= root->val;

    return (target == 0 ? 1 : 0)
            + dfs(root->left, target)
            + dfs(root->right, target);
}

int pathSum(struct TreeNode* root, int targetSum)
{
    if (!root) return 0;

    return dfs(root, targetSum)
            + pathSum(root->left, targetSum)
            + pathSum(root->right, targetSum);
}
