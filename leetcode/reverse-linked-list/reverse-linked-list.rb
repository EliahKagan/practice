# LeetCode #206 - Reverse Linked List
# https://leetcode.com/problems/reverse-linked-list

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
def reverse_list(head)
  acc = nil

  while head
    nxt = head.next
    head.next = acc
    acc = head
    head = nxt
  end

  acc
end
