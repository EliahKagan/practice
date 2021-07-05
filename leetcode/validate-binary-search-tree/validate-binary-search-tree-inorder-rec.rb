# LeetCode #98 - Validate Binary Search Tree
# https://leetcode.com/problems/validate-binary-search-tree/
# By recursive inorder traversal.

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
def is_valid_bst(root)
  prev = -Float::INFINITY

  dfs = proc do |node|
    next unless node

    dfs.call(node.left)

    return false unless prev < node.val
    prev = node.val

    dfs.call(node.right)
  end

  dfs.call(root)
  true
end
