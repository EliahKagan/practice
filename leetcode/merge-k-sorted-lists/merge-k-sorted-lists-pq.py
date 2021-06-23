# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Using a binary minheap priority queue.

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    @staticmethod
    def mergeKLists(lists: List[ListNode]) -> ListNode:
        sentinel = ListNode()
        pre = sentinel

        heap = [Box(node) for node in lists if node]
        heapq.heapify(heap)

        while heap:
            node = heapq.heappop(heap).node
            pre.next = node
            pre = pre.next
            if node.next:
                heapq.heappush(heap, Box(node.next))

        pre.next = None
        return sentinel.next


@functools.total_ordering
class Box:
    def __init__(self, node):
        self.node = node

    def __eq__(self, other):
        return self.node.val == other.node.val

    def __lt__(self, other):
        return self.node.val < other.node.val
