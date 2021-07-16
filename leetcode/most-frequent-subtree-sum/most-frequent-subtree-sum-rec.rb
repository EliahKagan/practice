# LeetCode #508 - Most Frequent Subtree Sum
# https://leetcode.com/problems/most-frequent-subtree-sum/
# By recursive DFS.

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
# @return {Integer[]}
def find_frequent_tree_sum(root)
  freqs = Hash.new(0)

  dfs = lambda do |node|
    return 0 unless node

    sum = node.val + dfs.call(node.left) + dfs.call(node.right)
    freqs[sum] += 1
    sum
  end

  dfs.call(root)
  max = freqs.values.max
  freqs.filter { |_, freq| freq == max }.map { |sum, _| sum }
end
