// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Naive approach, putting all lists' nodes in an array and sorting.

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
    template<typename OutputIt>
    OutputIt copy_links(ListNode* head, OutputIt out) noexcept
    {
        for (; head; head = head->next) *out++ = head;
        return out;
    }

    template<typename InputIt, typename OutputIt>
    OutputIt
    copy_all_links(InputIt first, const InputIt last, OutputIt out) noexcept
    {
        for_each(first, last, [&out](ListNode* const head) noexcept {
            out = copy_links(head, out);
        });
        return out;
    }

    template<typename InputIt>
    void sort_nodes_by_value(const InputIt first, const InputIt last) noexcept
    {
        sort(first, last, [](ListNode* const lhs,
                             ListNode* const rhs) noexcept {
            return lhs->val < rhs->val;
        });
    }

    template<typename InputIt>
    void connect_consecutive(InputIt first, const InputIt last) noexcept
    {
        for (assert(first != last); next(first) != last; ++first)
            (*first)->next = *next(first);
    }
}

ListNode* Solution::mergeKLists(const vector<ListNode*>& lists) noexcept
{
    auto nodes = vector<ListNode*>{};
    copy_all_links(cbegin(lists), cend(lists), back_inserter(nodes));
    sort_nodes_by_value(begin(nodes), end(nodes));
    nodes.push_back(nullptr);
    connect_consecutive(begin(nodes), end(nodes));
    return nodes.front();
}
