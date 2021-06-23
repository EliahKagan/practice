// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Using recursive divide and conquer.

/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    [[nodiscard]]
    static ListNode* mergeKLists(const vector<ListNode*>& lists) noexcept;
};

namespace {
    [[nodiscard]] ListNode* merge(ListNode* left, ListNode* right) noexcept
    {
        auto sentinel = ListNode{};
        auto pre = &sentinel;

        while (left && right) {
            if (right->val < left->val) {
                pre->next = right;
                right = right->next;
            } else {
                pre->next = left;
                left = left->next;
            }

            pre = pre->next;
        }

        pre->next = (left ? left : right);
        return sentinel.next;
    }

    template<typename It>
    [[nodiscard]] ListNode* merge_lists(const It first, const It last) noexcept
    {
        const auto count = distance(first, last);

        switch (count) {
        case 0:
            return nullptr;

        case 1:
            return *first;

        default:
            const auto mid = next(first, count / 2);
            return merge(merge_lists(first, mid), merge_lists(mid, last));
        }
    }
}

ListNode* Solution::mergeKLists(const vector<ListNode*>& lists) noexcept
{
    return merge_lists(cbegin(lists), cend(lists));
}
