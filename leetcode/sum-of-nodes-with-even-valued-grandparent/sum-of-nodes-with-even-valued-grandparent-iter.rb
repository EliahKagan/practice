# LeetCode #1315 -  Sum of Nodes with Even-Valued Grandparent
# https://leetcode.com/problems/sum-of-nodes-with-even-valued-grandparent/
# By iterative depth-first traversal.

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
  acc = 0
  stack = []
  stack << [root, false, false] if root

  until stack.empty?
    node, even_grandparent, even_parent = stack.pop
    acc += node.val if even_grandparent
    stack << [node.left, even_parent, node.val.even?] if node.left
    stack << [node.right, even_parent, node.val.even?] if node.right
  end

  acc
end
