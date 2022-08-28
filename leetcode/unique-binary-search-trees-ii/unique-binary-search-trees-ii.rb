# LeetCode #95 - Unique Binary Search Trees II
# https://leetcode.com/problems/unique-binary-search-trees-ii/
# By simple recursion, and sharing subtrees whenever convenient.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val = 0, left = nil, right = nil)
#         @val = val
#         @left = left
#         @right = right
#     end
# end
# @param {Integer} n
# @return {TreeNode[]}
def generate_trees(n)
  do_generate_trees(1, n)
end

# Helper function for generate_trees.
def do_generate_trees(low, high)
  return [nil] if high < low

  trees = []

  low.upto(high) do |val|
    lefts = do_generate_trees(low, val - 1)
    rights = do_generate_trees(val + 1, high)

    lefts.each do |left|
      rights.each do |right|
        trees << TreeNode.new(val, left, right)
      end
    end
  end

  trees
end
