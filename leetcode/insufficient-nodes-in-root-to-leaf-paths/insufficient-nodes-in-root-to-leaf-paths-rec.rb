# LeetCode 1080 - Insufficient Nodes in Root to Leaf Paths
# https://leetcode.com/problems/insufficient-nodes-in-root-to-leaf-paths/
# By recursive DFS, assigning to each link.

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
# @param {Integer} limit
# @return {TreeNode}
def sufficient_subset(root, limit)
  if root.left || root.right
    root.left &&= sufficient_subset(root.left, limit - root.val)
    root.right &&= sufficient_subset(root.right, limit - root.val)
    root.left || root.right ? root : nil
  elsif root.val < limit
    nil
  else
    root
  end
end
