# LeetCode #94 - Binary Tree Inorder Traversal
# https://leetcode.com/problems/binary-tree-inorder-traversal/
# Iterative solution.

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
def inorder_traversal(root)
  out = []
  stack = []

  while root || !stack.empty?
    # Go left as far as possible.
    while root
      stack << root
      root = root.left
    end

    # Visit the current node and prepare to go right.
    cur = stack.pop
    out << cur.val
    root = cur.right
  end

  out
end
