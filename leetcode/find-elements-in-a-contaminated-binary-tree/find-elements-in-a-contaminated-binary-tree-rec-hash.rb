# LeetCode #1261 - Find Elements in a Contaminated Binary Tree
# https://leetcode.com/problems/find-elements-in-a-contaminated-binary-tree/
# Recursively repairs and hashes the tree. Searches the hash table.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val = 0, left = nil, right = nil)
#         @val = val
#         @left = left
#         @right = right
#     end
# end

class FindElements
=begin
  :type root: TreeNode
=end
  def initialize(root)
    @values = Set.new

    dfs = lambda do |node, val|
      return unless node

      @values << val
      node.val = val
      dfs.call(node.left, val * 2 + 1)
      dfs.call(node.right, val * 2 + 2)
    end

    dfs.call(root, 0)
  end

=begin
  :type target: Integer
  :rtype: Boolean
=end
  def find(target)
    @values.include?(target)
  end
end

# Your FindElements object will be instantiated and called as such:
# obj = FindElements.new(root)
# param_1 = obj.find(target)
