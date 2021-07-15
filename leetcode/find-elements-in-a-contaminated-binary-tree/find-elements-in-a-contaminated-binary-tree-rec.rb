# LeetCode #1261 - Find Elements in a Contaminated Binary Tree
# https://leetcode.com/problems/find-elements-in-a-contaminated-binary-tree/
# Recursive repair. Recursive lookup, by traversing the tree.

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
    if (node = go(target)).nil?
      false
    elsif node.val == target
      true
    else
      raise "expected node value #{target}, got #{node.val}"
    end
  end

  private

  def go(target)
    return @root if target.zero?

    parent = go((target - 1) / 2)
    return nil unless parent

    target.odd? ? parent.left : parent.right
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
