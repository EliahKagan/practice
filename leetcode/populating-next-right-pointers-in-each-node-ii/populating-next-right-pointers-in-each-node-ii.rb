# LeetCode #116, #117 - Populating Next Right Pointers in Each Node, [I] & II
# https://leetcode.com/problems/populating-next-right-pointers-in-each-node/
# https://leetcode.com/problems/populating-next-right-pointers-in-each-node-ii/
# By following the next pointers populated in each previous row.
# The next pointers facilitate BFS (level-order traversal) in O(1) extra space.

# Definition for a Node.
# class Node
#     attr_accessor :val, :left, :right, :next
#     def initialize(val)
#         @val = val
#         @left, @right, @next = nil, nil, nil
#     end
# end

# @param {Node} root
# @return {Node}
def connect(root)
  sentinel = Node.new(nil)
  sentinel.next = root

  while sentinel.next
    parent = sentinel.next
    sentinel.next = nil
    child = sentinel

    while parent
      child = child.next = parent.left if parent.left
      child = child.next = parent.right if parent.right
      parent = parent.next
    end
  end

  root
end
