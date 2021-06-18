# LeetCode #590 - N-ary Tree Postorder Traversal
# https://leetcode.com/problems/n-ary-tree-postorder-traversal/
# Iterative solution by reversing right-to-left preorder.

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
def postorder(root)
  out = []
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    out << node.val
    stack.concat(node.children)
  end

  out.reverse!
end
