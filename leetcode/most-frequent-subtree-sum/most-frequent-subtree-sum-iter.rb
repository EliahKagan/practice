# LeetCode #508 - Most Frequent Subtree Sum
# https://leetcode.com/problems/most-frequent-subtree-sum/
# By iteratively implemented DFS.

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
def find_frequent_tree_sum(root)
  freqs = Hash.new(0)
  last_sum = nil
  stack = []
  stack << Frame.new(root) if root

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      frame.state = :go_right

      if frame.node.left
        stack << Frame.new(frame.node.left)
      else
        last_sum = 0
      end

    when :go_right
      frame.left_sum = last_sum
      frame.state = :retreat

      if frame.node.right
        stack << Frame.new(frame.node.right)
      else
        last_sum = 0
      end

    when :retreat
      last_sum += frame.left_sum + frame.node.val
      freqs[last_sum] += 1
      stack.pop

    else
      raise "unrecognized state #{frame.state}"
    end
  end

  max = freqs.values.max
  freqs.filter { |_, freq| freq == max }.map { |sum, _| sum }
end

# A stack frame for iteratively implemented recursive DFS.
class Frame
  attr_reader :node
  attr_accessor :left_sum, :state

  def initialize(node)
    @node = node
    @left_sum = nil
    @state = :go_left
  end
end
