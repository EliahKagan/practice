# LeetCode #138 - Copy List with Random Pointer
# https://leetcode.com/problems/copy-list-with-random-pointer/
# Hash table way (thread safe, doesn't even temporarily modify the input list).

# Definition for Node.
# class Node
#     attr_accessor :val, :next, :random
#     def initialize(val = 0)
#         @val = val
#		  @next = nil
#		  @random = nil
#     end
# end

# @param {Node} node
# @return {Node}
def copyRandomList(head)
  table = build_table(head)
  link_nodes(table, head)
  table[head]
end

# Creates a table whose keys are the original nodes and whose values are new
# nodes that have not yet been connected. The nil => nil mapping works
# automatically (since this is Ruby and nil is the default default value).
def build_table(head)
  table = {}

  while head
    table[head] = Node.new(head.val)
    head = head.next
  end

  table
end

# Connects the image nodes together by the next and random pointers, so the new
# list's structure corresponds exactly to that of the original list.
def link_nodes(table, head)
  while head
    image = table[head]
    image.next = table[head.next]
    image.random = table[head.random]
    head = head.next
  end
end
