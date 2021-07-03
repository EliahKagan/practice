// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// By hashing, linear O(M + N) runtime, implemented recursively.

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
    struct Key {
        int val;
        int left_id;
        int right_id;
    };

    [[nodiscard]]
    constexpr bool operator==(const Key& lhs, const Key& rhs) noexcept
    {
        return lhs.val == rhs.val
                && lhs.left_id == rhs.left_id
                && lhs.right_id == rhs.right_id;
    }

    [[nodiscard]]
    constexpr bool operator!=(const Key& lhs, const Key& rhs) noexcept
    {
        return !(lhs == rhs);
    }
}

template<>
struct std::hash<Key> {
    [[nodiscard]] constexpr size_t operator()(const Key& key) const noexcept
    {
        auto ret = bias;
        ret = ret * multiplier + key.val;
        ret = ret * multiplier + key.left_id;
        ret = ret * multiplier + key.right_id;
        return ret;
    }

private:
    static constexpr auto bias = size_t{1907};

    static constexpr auto multiplier = size_t{131'071};
};

namespace {
    using Table = unordered_map<Key, int>;

    int add(Table& table, const TreeNode* const node) noexcept
    {
        if (!node) return 0;

        const auto key = Key{node->val,
                             add(table, node->left),
                             add(table, node->right)};

        if (const auto it = table.find(key); it != end(table))
            return it->second;

        const auto id = static_cast<int>(size(table)) + 1;
        table.emplace(key, id);
        return id;
    }

    [[nodiscard]] optional<int>
    search(const Table& table, const TreeNode* const node) noexcept
    {
        if (!node) return 0;

        const auto left = search(table, node->left);
        if (!left) return nullopt;

        const auto right = search(table, node->right);
        if (!right) return nullopt;

        const auto it = table.find({node->val, *left, *right});
        if (it == end(table)) return nullopt;

        return it->second;
    }
}

bool Solution::isSubtree(const TreeNode* const root,
                         const TreeNode* const subRoot) noexcept
{
    auto table = Table{};
    add(table, root);
    return search(table, subRoot).has_value();
}
