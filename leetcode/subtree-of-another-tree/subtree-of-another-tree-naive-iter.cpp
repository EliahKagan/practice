// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// Naive solution, quadratic O(MN) runtime, implemented iteratively.

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
    [[nodiscard]] static bool
    isSubtree(const TreeNode* root, const TreeNode* subRoot) noexcept;
};

namespace {
    [[nodiscard]] bool equal_trees(const TreeNode* root1,
                                   const TreeNode* root2) noexcept
    {
        auto stack = std::stack<tuple<const TreeNode*, const TreeNode*>>{};

        for (stack.emplace(root1, root2); !empty(stack); ) {
            tie(root1, root2) = stack.top();
            stack.pop();

            if (!root1 && !root2) continue;

            if (!root1 || !root2 || root1->val != root2->val) return false;

            stack.emplace(root1->left, root2->left);
            stack.emplace(root1->right, root2->right);
        }

        return true;
    }
}

bool Solution::isSubtree(const TreeNode* root,
                         const TreeNode* const subRoot) noexcept
{
    if (!subRoot) return !root;

    auto stack = std::stack<const TreeNode*>{};

    for (stack.push(root); !empty(stack); ) {
        root = stack.top();
        stack.pop();

        if (!root) continue;

        if (equal_trees(root, subRoot)) return true;

        stack.push(root->left);
        stack.push(root->right);
    }

    return false;
}
