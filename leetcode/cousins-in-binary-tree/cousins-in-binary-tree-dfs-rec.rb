# LeetCode #993 - Cousins in Binary Tree
# https://leetcode.com/problems/cousins-in-binary-tree/
# By recursive DFS.

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
# @param {Integer} x
# @param {Integer} y
# @return {Boolean}
def is_cousins(root, x, y)
  x_path = parent_path(root, x)
  return false if x_path&.empty?

  y_path = parent_path(root, y)
  return false if y_path&.empty?

  x_path.size == y_path.size && x_path.last != y_path.last
end

def parent_path(root, val)
  path = []

  dfs = proc do |subroot|
    next unless subroot

    return path if subroot.val == val

    path << subroot
    dfs.call(subroot.left)
    dfs.call(subroot.right)
    path.pop
  end

  dfs.call(root)
  nil
end
