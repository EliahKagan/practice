# LeetCode #965 - Univalued Binary Tree
# https://leetcode.com/problems/univalued-binary-tree/
# Recursive solution.

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
  return true unless root

  dfs = ->(node) do
    return true unless node
    node.val == root.val && dfs.call(node.left) && dfs.call(node.right)
  end

  dfs.call(root)
end
