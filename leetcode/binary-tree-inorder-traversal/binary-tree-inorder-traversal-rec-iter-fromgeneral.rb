# LeetCode #94 - Binary Tree Inorder Traversal
# https://leetcode.com/problems/binary-tree-inorder-traversal/
# Special case of a general iteratively implemented recursive solution.

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
  traverse(root, ->(_) { }, ->(val) { out << val }, ->(_) { })
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

def traverse(root, f_pre, f_in, f_post)
  stack = []
  stack << Frame.new(root, :go_left) if root

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      f_pre.call(frame.node.val)
      stack << Frame.new(frame.node.left, :go_left) if frame.node.left
      frame.state = :go_right
    when :go_right
      f_in.call(frame.node.val)
      stack << Frame.new(frame.node.right, :go_left) if frame.node.right
      frame.state = :retreat
    when :retreat
      f_post.call(frame.node.val)
      stack.pop
    end
  end
end
