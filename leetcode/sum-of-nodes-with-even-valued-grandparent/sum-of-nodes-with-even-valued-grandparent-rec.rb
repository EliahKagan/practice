# LeetCode #1315 -  Sum of Nodes with Even-Valued Grandparent
# https://leetcode.com/problems/sum-of-nodes-with-even-valued-grandparent/
# By recursive depth-first traversal.

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
def sum_even_grandparent(root)
  seg_helper(root, false, false)
end

def seg_helper(node, even_grandparent, even_parent)
  return 0 unless node

  (even_grandparent ? node.val : 0) +
      seg_helper(node.left, even_parent, node.val.even?) +
      seg_helper(node.right, even_parent, node.val.even?)
end
