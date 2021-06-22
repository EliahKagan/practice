# LeetCode #21 - Merge Two Sorted Lists
# https://leetcode.com/problems/merge-two-sorted-lists/

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode} l1
# @param {ListNode} l2
# @return {ListNode}
def merge_two_lists(l1, l2)
  pre = sentinel = ListNode.new

  while l1 && l2
    if l2.val < l1.val
      pre.next = l2
      l2 = l2.next
    else
      pre.next = l1
      l1 = l1.next
    end

    pre = pre.next
  end

  pre.next = l1 || l2
  sentinel.next
end
