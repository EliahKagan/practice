// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// Naive solution, quadratic O(MN) runtime, implemented recursively.

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
    [[nodiscard]] static constexpr bool
    isSubtree(const TreeNode* root, const TreeNode* subRoot) noexcept;
};

namespace {
    [[nodiscard]] constexpr bool
    equal_trees(const TreeNode* const root1,
                const TreeNode* const root2) noexcept
    {
        if (!root1 || !root2) return !root1 && !root2;

        return root1->val == root2->val
                && equal_trees(root1->left, root2->left)
                && equal_trees(root1->right, root2->right);
    }
}

constexpr bool Solution::isSubtree(const TreeNode* const root,
                                   const TreeNode* const subRoot) noexcept
{
    if (equal_trees(root, subRoot)) return true;

    if (!root) return false;

    return isSubtree(root->left, subRoot) || isSubtree(root->right, subRoot);
}
