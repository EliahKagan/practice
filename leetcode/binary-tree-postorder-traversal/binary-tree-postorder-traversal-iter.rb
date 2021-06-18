# LeetCode #145 - Binary Tree Postorder Traversal
# https://leetcode.com/problems/binary-tree-postorder-traversal/
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
def postorder_traversal(root)
  out = []
  stack = []
  last = nil

  while root || !stack.empty?
    # Go left as far as possible.
    while root
      stack << root
      root = root.left
    end

    cur = stack.last

    if cur.right && cur.right != last
      # We can go right from here but we haven't. Do that next.
      root = cur.right
    else
      # We can't go right, or already did. Visit the current node and retreat.
      out << cur.val
      last = cur
      stack.pop
    end
  end

  out
end
