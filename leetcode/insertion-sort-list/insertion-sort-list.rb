# LeetCode #147 - Insertion Sort List
# https://leetcode.com/problems/insertion-sort-list/

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode} head
# @return {ListNode}
def insertion_sort_list(head)
  sentinel = ListNode.new

  while head
    pre = sentinel
    pre = pre.next while pre.next && pre.next.val < head.val

    next_head = head.next
    head.next = pre.next
    pre.next = head
    head = next_head
  end

  sentinel.next
end
