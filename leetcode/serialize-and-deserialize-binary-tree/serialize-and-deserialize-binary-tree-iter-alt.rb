# LeetCode #297 - Serialize and Deserialize Binary Tree
# https://leetcode.com/problems/serialize-and-deserialize-binary-tree/
# Iteratively implemented recursive postorder traversal serialization.
# Stack-based RPN-calculator deserialization.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val)
#         @val = val
#         @left, @right = nil, nil
#     end
# end

# A stack frame for iteratively implemented recursive binary tree traversal.
class Frame
  attr_reader :node
  attr_accessor :state

  def initialize(node)
    @node = node
    @state = :go_left
  end
end

# Encodes a tree to a single string.
#
# @param {TreeNode} root
# @return {string}
def serialize(root)
  tokens = []
  stack = [Frame.new(root)]

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      if frame.node
        frame.state = :go_right
        stack << Frame.new(frame.node.left)
      else
        tokens << '.'
        stack.pop
      end

    when :go_right
      frame.state = :retreat
      stack << Frame.new(frame.node.right)

    when :retreat
      tokens << frame.node.val
      stack.pop

    else
      raise "unrecognized state: #{frame.state}"
    end
  end

  tokens.join(' ')
end

# Decodes your encoded data to tree.
#
# @param {string} data
# @return {TreeNode}
def deserialize(data)
  stack = []

  data.split.each do |token|
    if token == '.'
      stack << nil
    else
      node = TreeNode.new(Integer(token))
      node.right = stack.pop
      node.left = stack.pop
      stack << node
    end
  end

  raise "syntax error, can't deserialize" unless stack.size == 1
  stack.pop
end


# Your functions will be called as such:
# deserialize(serialize(data))
