# LeetCode #103 - Binary Tree Zigzag Level Order Traversal
# https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/

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
# @return {Integer[][]}
def zigzag_level_order(root)
  ret = []
  queue = []
  queue << root if root

  until queue.empty?
    level = []

    queue.size.times do
      root = queue.shift
      level << root.val
      queue << root.left if root.left
      queue << root.right if root.right
    end

    level.reverse! if ret.size.odd?
    ret << level
  end

  ret
end
