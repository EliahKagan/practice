# Maximum Depth of Binary Tree
# https://leetcode.com/problems/maximum-depth-of-binary-tree/
# By BFS, counting number of levels.

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
  depth = 0
  queue = []
  queue << root if root

  until queue.empty?
    depth += 1

    queue.size.times do
      root = queue.shift
      queue << root.left if root.left
      queue << root.right if root.right
    end
  end

  depth
end
