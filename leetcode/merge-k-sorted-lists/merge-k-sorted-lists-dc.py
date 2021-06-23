# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Using recursive divide and conquer.

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    @staticmethod
    def mergeKLists(lists: List[ListNode]) -> ListNode:
        length = len(lists)

        if length == 0:
            return None

        if length == 1:
            return lists[0]

        mid = length // 2

        return Solution._merge(Solution.mergeKLists(lists[:mid]),
                               Solution.mergeKLists(lists[mid:]))

    @staticmethod
    def _merge(first, second):
        sentinel = ListNode()
        pre = sentinel

        while first and second:
            if second.val < first.val:
                pre.next = second
                second = second.next
            else:
                pre.next = first
                first = first.next

            pre = pre.next

        pre.next = first or second
        return sentinel.next
