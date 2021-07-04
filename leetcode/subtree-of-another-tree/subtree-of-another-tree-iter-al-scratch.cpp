#include <functional>
#include <iostream>
#include <iterator>
#include <optional>
#include <stack>
#include <unordered_map>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};

// LeetCode #572 - Subtree of Another Tree
// https://leetcode.com/problems/subtree-of-another-tree/
// By hashing, linear O(M + N) runtime, implemented iteratively. The state
// machine uses "arm's length" recursion (which is rarely appropriate in actual
// recursive code, but which sometimes simplifies or improves the performance
// of state machines simulating recursion).

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

    [[maybe_unused, nodiscard]]
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

    enum class State { go_left, go_right, retreat };

    struct Frame {
        explicit constexpr Frame(const TreeNode* const node_) noexcept
            : node{node_} { }

        const TreeNode* node;

        int left_id {-1};

        State state {State::go_left};
    };

    template<bool AddIfAbsent>
    bool traverse(conditional_t<AddIfAbsent, Table&, const Table&> table,
                  const TreeNode* const root) noexcept
    {
        auto last_id = -1; // "return" cell
        auto stack = std::stack<Frame>{};

        const auto visit = [&](const TreeNode* const node) noexcept {
            if (node)
                stack.emplace(node);
            else
                last_id = 0;
        };

        for (visit(root); !empty(stack); ) {
            auto& frame = stack.top();

            switch (frame.state) {
            case State::go_left:
                frame.state = State::go_right;
                visit(frame.node->left);
                break;

            case State::go_right:
                frame.left_id = last_id;
                frame.state = State::retreat;
                visit(frame.node->right);
                break;

            case State::retreat:
                const auto key = Key{frame.node->val, frame.left_id, last_id};

                if (const auto it = table.find(key); it != end(table)) {
                    last_id = it->second;
                } else if constexpr (AddIfAbsent) {
                    last_id = static_cast<int>(size(table)) + 1;
                    table.emplace(key, last_id);
                } else {
                    return false;
                }

                stack.pop();
            }
        }

        return true;
    }
}

bool Solution::isSubtree(const TreeNode* const root,
                         const TreeNode* const subRoot) noexcept
{
    auto table = Table{};
    traverse<true>(table, root);
    return traverse<false>(table, subRoot);
}

int main()
{
    auto left = TreeNode{20};
    auto right = TreeNode{30};
    auto root = TreeNode{10, &left, &right};

    cout << boolalpha << Solution::isSubtree(&root, &right) << '\n';
}
