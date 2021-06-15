# LeetCode #437 - Path Sum III
# https://leetcode.com/problems/path-sum-iii/
# Prefix-sum hashing solution. Runs in linear time.

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
# @param {Integer} target_sum
# @return {Integer}
def path_sum(root, target_sum)
  history = Hash.new(0)
  history[0] = 1

  dfs = ->(node, acc) do
    return 0 unless node

    acc += node.val
    count = history[acc - target_sum]

    history[acc] += 1
    count += dfs.call(node.left, acc)
    count += dfs.call(node.right, acc)
    history[acc] -= 1

    count
  end

  dfs.call(root, 0)
end
