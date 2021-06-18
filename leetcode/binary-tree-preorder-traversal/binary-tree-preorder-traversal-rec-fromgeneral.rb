# LeetCode #144 - Binary Tree Preorder Traversal
# https://leetcode.com/problems/binary-tree-preorder-traversal/
# Special case of a general recursive solution.

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
  traverse(root, ->(val) { out << val }, ->(_) { }, ->(_) { })
  out
end

def traverse(root, f_pre, f_in, f_post)
  dfs = ->(node) do
    return unless node

    f_pre.call(node.val)
    dfs.call(node.left)
    f_in.call(node.val)
    dfs.call(node.right)
    f_post.call(node.val)
  end

  dfs.call(root)
end
