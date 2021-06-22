# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Using recursive divide and conquer.

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode[]} lists
# @return {ListNode}
def merge_k_lists(lists)
  case lists.size
  when 0
    nil
  when 1
    lists.first
  when 2
    merge(*lists)
  else
    mid = lists.size / 2
    merge(merge_k_lists(lists[0...mid]), merge_k_lists(lists[mid..-1]))
  end
end

def merge(first, second)
  pre = sentinel = ListNode.new

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
