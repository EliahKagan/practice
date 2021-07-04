// LeetCode #1379 - Find a Corresponding Node of a Binary Tree in a Clone of That Tree
// https://leetcode.com/problems/find-a-corresponding-node-of-a-binary-tree-in-a-clone-of-that-tree/
// By iterative DFS. Permits repeated values (does not examine value).

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
    [[nodiscard]] static TreeNode*
    getTargetCopy(const TreeNode* original,
                  TreeNode* cloned,
                  const TreeNode* target) noexcept;
};

TreeNode* Solution::getTargetCopy(const TreeNode* original,
                                  TreeNode* cloned,
                                  const TreeNode* const target) noexcept
{
    if (!original) return nullptr;

    auto stack = std::stack<tuple<const TreeNode*, TreeNode*>>{};

    for (stack.emplace(original, cloned); !empty(stack); ) {
        tie(original, cloned) = stack.top();
        stack.pop();

        if (original == target) return cloned;

        if (original->left) stack.emplace(original->left, cloned->left);
        if (original->right) stack.emplace(original->right, cloned->right);
    }

    return nullptr;
}
