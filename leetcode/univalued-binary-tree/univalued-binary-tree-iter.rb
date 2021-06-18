# LeetCode #965 - Univalued Binary Tree
# https://leetcode.com/problems/univalued-binary-tree/
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
# @return {Boolean}
def is_unival_tree(root)
  stack = []
  stack << root if root

  until stack.empty?
    node = stack.pop
    return false if node.val != root.val

    stack << node.left if node.left
    stack << node.right if node.right
  end

  true
end
