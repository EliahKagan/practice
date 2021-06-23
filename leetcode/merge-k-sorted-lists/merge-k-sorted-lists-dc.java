// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Using recursive divide and conquer.

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        return mergeLists(lists, 0, lists.length);
    }

    private ListNode mergeLists(ListNode[] lists, int from, int toExclusive) {
        var count = toExclusive - from;

        switch (count) {
        case 0:
            return null;

        case 1:
            return lists[from];

        default:
            var mid = from + count / 2;

            return merge(mergeLists(lists, from, mid),
                         mergeLists(lists, mid, toExclusive));
        }
    }

    private ListNode merge(ListNode first, ListNode second) {
        var sentinel = new ListNode();
        var pre = sentinel;

        while (first != null && second != null) {
            if (second.val < first.val) {
                pre.next = second;
                second = second.next;
            } else {
                pre.next = first;
                first = first.next;
            }

            pre = pre.next;
        }

        pre.next = (first == null ? second : first);
        return sentinel.next;
    }
}
