# LeetCode 1080 - Insufficient Nodes in Root to Leaf Paths
# https://leetcode.com/problems/insufficient-nodes-in-root-to-leaf-paths/
# By iterative DFS (using a state machine), assigning to each link.

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
# @param {Integer} limit
# @return {TreeNode}
def sufficient_subset(root, limit)
  ret = nil
  stack = [Frame.new(root, limit)]

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      unless frame.node.left || frame.node.right
        ret = frame.node.val < frame.limit ? nil : frame.node
        stack.pop
        next
      end

      frame.state = :go_right

      if frame.node.left
        stack << Frame.new(frame.node.left, frame.limit - frame.node.val)
      else
        ret = nil
      end

    when :go_right
      frame.node.left = ret
      frame.state = :retreat

      if frame.node.right
        stack << Frame.new(frame.node.right, frame.limit - frame.node.val)
      else
        ret = nil
      end

    when :retreat
      frame.node.right = ret
      ret = frame.node.left || frame.node.right ? frame.node : nil
      stack.pop

    else
      raise "unrecognized state #{frame.state}"
    end
  end

  ret
end

# A stack frame for iteratively implemented recursive binary tree traversal.
class Frame
  attr_reader :node, :limit
  attr_accessor :state

  def initialize(node, limit)
    @node = node
    @limit = limit
    @state = :go_left
  end
end
