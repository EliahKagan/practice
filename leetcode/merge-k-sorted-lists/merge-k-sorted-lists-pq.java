// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Using a priority queue.

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
        var sentinel = new ListNode();
        var pre = sentinel;

        for (var heap = getInitialHeap(lists); !heap.isEmpty(); ) {
            var node = heap.remove();
            pre.next = node;
            pre = pre.next;
            if (node.next != null) heap.add(node.next);
        }

        pre.next = null;
        return sentinel.next;
    }

    private static Queue<ListNode> getInitialHeap(ListNode[] lists) {
        Queue<ListNode> heap =
            new PriorityQueue<>(Comparator.comparing(node -> node.val));

        Stream.of(lists).filter(Objects::nonNull).forEachOrdered(heap::add);

        return heap;
    }
}
