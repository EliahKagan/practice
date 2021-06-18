# LeetCode #94 - Binary Tree Inorder Traversal
# https://leetcode.com/problems/binary-tree-inorder-traversal/
# Iteratively implemented recursive solution with tail-call elimination.

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
def inorder_traversal(root)
  out = []
  stack = []
  stack << Frame.new(root, :go_left) if root

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      stack << Frame.new(frame.node.left, :go_left) if frame.node.left
      frame.state = :go_right
    when :go_right
      out << frame.node.val
      stack.pop
      stack << Frame.new(frame.node.right, :go_left) if frame.node.right
    end
  end

  out
end

# A stack frame for iteratively implemented recursive binary tree traversal.
class Frame
  attr_reader :node
  attr_accessor :state

  def initialize(node, state)
    @node = node
    @state = state
  end
end
