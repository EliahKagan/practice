# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By copying to an array, sorting the array, and relinking.
# (Though not a very interesting approach, this is often the fastest.)

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

  nodes = node_array(head).sort_by!(&:val)
  connect(nodes)
  nodes.first
end

def node_array(head)
  nodes = []

  while head
    nodes << head
    head = head.next
  end

  nodes
end

def connect(nodes)
  nodes.each_cons(2) { |left, right| left.next = right }
  nodes.last.next = nil
end
