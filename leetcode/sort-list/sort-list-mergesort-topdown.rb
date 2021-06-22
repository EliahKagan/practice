# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By recursive top-down mergesort. Uses O(log N) extra space (for call stack).

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
  return head unless head && head.next

  first, second = split(head)
  merge(sort_list(first), sort_list(second))
end

def split(head)
  raise 'refusing to split empty list' unless head

  slow = head
  fast = head.next
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end

  mid = slow.next
  slow.next = nil
  [head, mid]
end

def merge(first, second)
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
  sentinel.next
end
