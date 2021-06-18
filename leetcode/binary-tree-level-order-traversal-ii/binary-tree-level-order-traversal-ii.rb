# LeetCode #107 - Binary Tree Level Order Traversal II
# https://leetcode.com/problems/binary-tree-level-order-traversal-ii/

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
def level_order_bottom(root)
  out = []
  queue = []
  queue << root if root

  until queue.empty?
    row = []

    queue.size.times do
      node = queue.shift
      row << node.val
      queue << node.left if node.left
      queue << node.right if node.right
    end

    out << row
  end

  out.reverse!
end
