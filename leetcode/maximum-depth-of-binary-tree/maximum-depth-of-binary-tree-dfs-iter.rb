# Maximum Depth of Binary Tree
# https://leetcode.com/problems/maximum-depth-of-binary-tree/
# By iterative DFS, taking maximum stack depth.

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
      # We can go right but haven't. Do that next.
      root = cur.right
    else
      # We've gone right, or can't. Measure depth and retreat.
      acc = stack.size if acc < stack.size
      last = stack.pop
    end
  end

  acc
end
