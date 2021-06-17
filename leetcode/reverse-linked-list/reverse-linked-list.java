// LeetCode #206 - Reverse Linked List
// https://leetcode.com/problems/reverse-linked-list

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
    public ListNode reverseList(ListNode head) {
        ListNode acc = null;

        while (head != null) {
            var next = head.next;
            head.next = acc;
            acc = head;
            head = next;
        }

        return acc;
    }
}
