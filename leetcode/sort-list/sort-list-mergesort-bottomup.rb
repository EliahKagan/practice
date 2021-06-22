# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By iterative bottom-up mergesort. Uses O(1) extra space.

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
def sort_list(head)
  return nil unless head

  again = true
  delta = 1

  while again
    head, again = merge_pass(head, delta)
    delta *= 2
  end

  head
end

def merge_pass(head, delta)
  sentinel = ListNode.new
  sentinel.next = head
  pre = sentinel
  merged = false

  while pre
    left = advance(pre, 1)
    pre_mid = advance(left, delta - 1)
    mid = advance(pre_mid, 1)
    break unless mid

    pre_right = advance(mid, delta - 1)
    right = advance(pre_right, 1)

    pre_mid.next = nil
    pre_right.next = nil if right

    first, last = merge(left, mid)
    pre.next = first
    last.next = right

    merged = true
    pre = last
  end

  [sentinel.next, merged]
end

def advance(head, length)
  length.times do
    break unless head
    head = head.next
  end

  head
end

def merge(first, second)
  raise "refusing to merge two empty lists" unless first || second

  sentinel = ListNode.new
  pre = sentinel

  while first && second
    if second.val < first.val
      pre.next = second
      second = second.next
    else
      pre.next = first
      first = first.next
    end
    pre = pre.next
  end

  pre.next = first || second
  pre = pre.next while pre.next
  [sentinel.next, pre]
end
