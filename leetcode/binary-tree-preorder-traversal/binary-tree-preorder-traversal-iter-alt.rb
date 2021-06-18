# LeetCode #144 - Binary Tree Preorder Traversal
# https://leetcode.com/problems/binary-tree-preorder-traversal/
# Alternative iterative solution.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val = 0, left = nil, right = nil)
#         @val = val
#         @left = left
#         @right = right
#     end
# end
# @param {TreeNode} root
# @return {Integer[]}
def preorder_traversal(root)
  out = []
  stack = []

  while root || !stack.empty?
    # Go left as far as possible, visiting each node.
    while root
      out << root.val
      stack << root
      root = root.left
    end

    # If it is possible to go right, we'll do that next.
    root = stack.pop.right
  end

  out
end
