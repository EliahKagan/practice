// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Using a priority queue.

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
    constexpr auto compare = [](const auto lhs, const auto rhs) noexcept {
        return lhs->val > rhs->val;
    };

    [[nodiscard]] vector<ListNode*>
    without_nulls(const vector<ListNode*>& lists) noexcept
    {
        auto out = vector<ListNode*>{};
        remove_copy(cbegin(lists), cend(lists), back_inserter(out), nullptr);
        return out;
    }
}

[[nodiscard]]
ListNode* Solution::mergeKLists(const vector<ListNode*>& lists) noexcept
{
    auto sentinel = ListNode{};
    auto pre = &sentinel;
    auto heap = priority_queue{compare, without_nulls(lists)};

    while (!empty(heap)) {
        const auto head = heap.top();
        heap.pop();
        pre = pre->next = head;
        if (head->next) heap.push(head->next);
    }

    return sentinel.next;
}
