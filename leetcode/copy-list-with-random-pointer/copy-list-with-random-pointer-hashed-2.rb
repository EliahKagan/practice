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
  each_node(head) { |node| table[node] = Node.new(node.val) }
  table
end

# Connects the image nodes together by the next and random pointers, so the new
# list's structure corresponds exactly to that of the original list.
def link_nodes(table, head)
  each_node(head) do |node|
    image = table[node]
    image.next = table[node.next]
    image.random = table[node.random]
  end
end

def each_node(head)
  while head
    yield head
    head = head.next
  end
end
