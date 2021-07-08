# Maximum Depth of Binary Tree
# https://leetcode.com/problems/maximum-depth-of-binary-tree/
# By BFS, propagating depths from root to leaf.

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
# @return {Integer}
def max_depth(root)
  acc = 0
  queue = []
  queue << [root, 1] if root

  until queue.empty?
    root, depth = queue.shift
    acc = depth if acc < depth
    queue << [root.left, depth + 1] if root.left
    queue << [root.right, depth + 1] if root.right
  end

  acc
end
