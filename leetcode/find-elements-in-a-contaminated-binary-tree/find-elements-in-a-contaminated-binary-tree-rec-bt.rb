# LeetCode #1261 - Find Elements in a Contaminated Binary Tree
# https://leetcode.com/problems/find-elements-in-a-contaminated-binary-tree/
# Repair recursively. Iterative search, traversing as a (target + 1) bit trie.

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
    repair(root, 0)
    @root = root
  end

=begin
  :type target: Integer
  :rtype: Boolean
=end
  def find(target)
    node = @root

    (target + 1).to_s(2).each_char.drop(1).each do |bit|
      break unless node
      node = (bit == '0' ? node.left : node.right)
    end

    !!node
  end
end

def repair(root, val)
  return unless root

  root.val = val
  repair(root.left, val * 2 + 1)
  repair(root.right, val * 2  + 2)
end

# Your FindElements object will be instantiated and called as such:
# obj = FindElements.new(root)
# param_1 = obj.find(target)
