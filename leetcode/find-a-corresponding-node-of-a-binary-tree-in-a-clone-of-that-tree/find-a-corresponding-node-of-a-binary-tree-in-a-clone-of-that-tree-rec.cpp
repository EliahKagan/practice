// LeetCode #1379 - Find a Corresponding Node of a Binary Tree in a Clone of That Tree
// https://leetcode.com/problems/find-a-corresponding-node-of-a-binary-tree-in-a-clone-of-that-tree/
// By recursive DFS. Permits repeated values (does not examine value).

/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */

class Solution {
public:
    [[nodiscard]] static constexpr TreeNode*
    getTargetCopy(const TreeNode* original,
                  TreeNode* cloned,
                  const TreeNode* target) noexcept;
};

constexpr TreeNode*
Solution::getTargetCopy(const TreeNode* const original,
                        TreeNode* const cloned,
                        const TreeNode* const target) noexcept
{
    if (!original) return nullptr;

    if (original == target) return cloned;

    if (const auto left =
            getTargetCopy(original->left, cloned->left, target))
        return left;

    if (const auto right =
            getTargetCopy(original->right, cloned->right, target))
        return right;

    return nullptr;
}
