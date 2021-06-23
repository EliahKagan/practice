# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Naive approach, putting all lists' nodes in an array and sorting. This can be
# expected to perform very well, since Python uses Timsort, which is highly
# adaptive and detects monotone runs.

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    @staticmethod
    def mergeKLists(lists: List[ListNode]) -> ListNode:
        nodes = []
        for head in lists:
            append_nodes(nodes, head)

        nodes.sort(key=attrgetter('val'))
        nodes.append(None)
        connect_consecutive(nodes)
        return nodes[0]


def append_nodes(sink, source):
    while source:
        sink.append(source)
        source = source.next


def connect_consecutive(nodes):
    for i in range(len(nodes) - 1):
        nodes[i].next = nodes[i + 1]
