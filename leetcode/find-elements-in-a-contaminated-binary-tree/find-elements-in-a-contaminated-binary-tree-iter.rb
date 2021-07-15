# LeetCode #1261 - Find Elements in a Contaminated Binary Tree
# https://leetcode.com/problems/find-elements-in-a-contaminated-binary-tree/
# Repairs the tree iteratively. Iterative lookup, by traversing the tree.

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
    @root = root

    stack = []

    visit = lambda do |node, val|
      return unless node

      node.val = val
      stack << node
    end

    visit.call(root, 0)

    until stack.empty?
      node = stack.pop
      visit.call(node.left, node.val * 2 + 1)
      visit.call(node.right, node.val * 2 + 2)
    end
  end

=begin
  :type target: Integer
  :rtype: Boolean
=end
  def find(target)
    path = []
    until target.zero?
      path << (target.odd? ? :left : :right)
      target = (target - 1) / 2
    end

    node = @root
    while node && (direction = path.pop)
      node = node.public_send(direction)
    end

    !!node
  end
end

# Your FindElements object will be instantiated and called as such:
# obj = FindElements.new(root)
# param_1 = obj.find(target)
