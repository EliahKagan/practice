# LeetCode #572 - Subtree of Another Tree
# https://leetcode.com/problems/subtree-of-another-tree/
# By hashing, linear O(M + N) runtime, implemented iteratively. The state
# machine implements the same logic as in subtree-of-another-tree.rb.

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
# @param {TreeNode} sub_root
# @return {Boolean}
def is_subtree(root, sub_root)
  table = {} # val, left_id, right_id => id
  traverse(root, table, true)
  traverse(sub_root, table, false)
end

def traverse(root, table, add_if_absent)
  stack = []
  stack << Frame.new(root) if root
  last_id = nil # "return" cell

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      if frame.node
        frame.state = :go_right
        stack << Frame.new(frame.node.left)
      else
        last_id = 0
        stack.pop
      end

    when :go_right
      frame.left_id = last_id
      frame.state = :retreat
      stack << Frame.new(frame.node.right)

    when :retreat
      key = [frame.node.val, frame.left_id, last_id]
      last_id = table[key]

      unless last_id
        return false unless add_if_absent
        table[key] = last_id = table.size + 1
      end

      stack.pop
    end
  end

  true
end

# A stack frame for iteratively implemented recursive binary tree traversal.
class Frame
  attr_reader :node
  attr_accessor :left_id
  attr_accessor :state

  def initialize(node)
    @node = node
    @left_id = nil
    @state = :go_left
  end
end
