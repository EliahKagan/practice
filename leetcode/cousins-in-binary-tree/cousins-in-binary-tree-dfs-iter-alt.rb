# LeetCode #993 - Cousins in Binary Tree
# https://leetcode.com/problems/cousins-in-binary-tree/
# By iterative DFS (alternate way).

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
  x_depth, x_parent = depth_and_parent(root, x)
  return false unless x_depth

  y_depth, y_parent = depth_and_parent(root, y)
  return false unless y_depth

  x_depth == y_depth && x_parent != y_parent
end

def depth_and_parent(root, val)
  stack = [[0, nil, root]]

  until stack.empty?
    depth, parent, child = stack.pop
    next unless child
    return [depth, parent] if child.val == val
    stack << [depth + 1, child, child.left] << [depth + 1, child, child.right]
  end

  [nil, nil]
end
