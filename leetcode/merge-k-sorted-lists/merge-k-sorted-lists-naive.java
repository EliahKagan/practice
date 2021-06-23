// LeetCode #23 - Merge k Sorted Lists
// https://leetcode.com/problems/merge-k-sorted-lists/
// Naive approach, putting all lists' nodes in an array and sorting.

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
        List<ListNode> nodes = new ArrayList<>();
        Stream.of(lists).forEachOrdered(head -> appendNodes(nodes, head));
        nodes.sort(Comparator.comparing(node -> node.val));
        nodes.add(null);
        connectConsecutive(nodes);
        return nodes.get(0);
    }

    private static void appendNodes(List<ListNode> sink, ListNode source) {
        for (; source != null; source = source.next) sink.add(source);
    }

    private static void connectConsecutive(List<ListNode> nodes) {
        for (var i = 1; i < nodes.size(); ++i)
            nodes.get(i - 1).next = nodes.get(i);
    }
}
