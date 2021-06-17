# LeetCode #92 - Reverse Linked List II
# https://leetcode.com/problems/reverse-linked-list-ii

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end

# @param {ListNode} head
# @param {Integer} m
# @param {Integer} n
# @return {ListNode}
def reverse_between(head, m, n)
  return head if n - m < 1

  sentinel = ListNode.new(nil, head)
  pre = advance(sentinel, m - 1)
  first = pre.next
  last = advance(first, n - m)
  post = last.next

  pre.next = last.next = nil
  raise "splice boundary doesn't match" unless reverse(first) == last

  pre.next = last
  first.next = post
  sentinel.next
end

def advance(head, count)
  count.times { head = head.next }
  head
end

def reverse(head)
  acc = nil

  while head
    nxt = head.next
    head.next = acc
    acc = head
    head = nxt
  end

  acc
end
