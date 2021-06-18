# LeetCode #429 - N-ary Tree Level Order Traversal
# https://leetcode.com/problems/n-ary-tree-level-order-traversal/

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {List[List[int]]}
def levelOrder(root)
  out = []
  queue = []
  queue << root if root

  until queue.empty?
    row = []

    queue.size.times do
      node = queue.shift
      row << node.val
      queue.concat(node.children)
    end

    out << row
  end

  out
end
