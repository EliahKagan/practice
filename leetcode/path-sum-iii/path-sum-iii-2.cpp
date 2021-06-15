// LeetCode #437 - Path Sum III
// https://leetcode.com/problems/path-sum-iii/
// Prefix-sum hashing solution using a fixed-point combinator.
// Runs in linear time.

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    static int pathSum(const TreeNode* root, int targetSum) noexcept;
};

int Solution::pathSum(const TreeNode *const root, const int targetSum) noexcept
{
    auto history = unordered_map<int, int>{};
    history[0] = 1;

    const auto
    dfs = [&](const auto& me, const TreeNode* const node, int acc) noexcept {
        if (!node) return 0;

        acc += node->val;
        auto count = history[acc - targetSum];

        ++history[acc];
        count += me(me, node->left, acc);
        count += me(me, node->right, acc);
        --history[acc];

        return count;
    };

    return dfs(dfs, root, 0);
}
