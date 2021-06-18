# LeetCode #589 - N-ary Tree Preorder Traversal
# https://leetcode.com/problems/n-ary-tree-preorder-traversal/
# Simple iterative solution with a node stack.

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {List[int]}
def preorder(root)
  out = []
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    out << node.val
    stack.concat(node.children.reverse)
  end

  out
end
