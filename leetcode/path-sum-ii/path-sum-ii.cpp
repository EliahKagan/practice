// LeetCode #113 - Path Sum II
// https://leetcode.com/problems/path-sum-ii/

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
    [[nodiscard]] static vector<vector<int>>
    pathSum(const TreeNode* root, int targetSum) noexcept;
};

vector<vector<int>>
Solution::pathSum(const TreeNode* const root, int targetSum) noexcept
{
    auto all_paths = vector<vector<int>>{};
    auto path = vector<int>{};

    const function<void(const TreeNode*)>
    dfs {[&](const TreeNode* const node) noexcept {
        if (!node) return;

        targetSum -= node->val;
        path.push_back(node->val);

        if (node->left || node->right) {
            dfs(node->left);
            dfs(node->right);
        } else if (targetSum == 0) {
            all_paths.push_back(path);
        }

        path.pop_back();
        targetSum += node->val;
    }};

    dfs(root);
    return all_paths;
}
