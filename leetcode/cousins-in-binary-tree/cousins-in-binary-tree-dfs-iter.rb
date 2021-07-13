# LeetCode #993 - Cousins in Binary Tree
# https://leetcode.com/problems/cousins-in-binary-tree/
# By iterative DFS.

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
  return false if x_path.nil? || x_path.empty?

  y_path = parent_path(root, y)
  return false if y_path.nil? || y_path.empty?

  x_path.size == y_path.size && x_path.last != y_path.last
end

def parent_path(root, val)
  path = []
  last = nil

  while root || !path.empty?
    # Go left as far as possible.
    while root
      return path if root.val == val
      path << root
      root = root.left
    end

    right = path.last.right

    if right && right != last
      # We can go right, but we haven't. Do that next.
      root = right
    else
      # We can't go right or already did. Retreat.
      last = path.pop
    end

    nil
  end
end
