# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Naive approach, putting all lists' nodes in an array and sorting.

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
  nodes = []

  lists.each do |head|
    while head
      nodes << head
      head = head.next
    end
  end

  nodes.sort_by!(&:val)
  nodes << nil
  nodes.each_cons(2) { |left, right| left.next = right }
  nodes.first
end
