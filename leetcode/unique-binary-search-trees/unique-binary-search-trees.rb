# LeetCode #96 - Unique Binary Search Trees
# https://leetcode.com/problems/unique-binary-search-trees/
# By bottom-up dynamic programming (tabulation).

# @param {Integer} n
# @return {Integer}
def num_trees(n)
  opt = [1]

  1.upto(n) do |i|
    opt[i] = (1..i).sum { |j| opt[j - 1] * opt[i - j] }
  end

  opt[n]
end
