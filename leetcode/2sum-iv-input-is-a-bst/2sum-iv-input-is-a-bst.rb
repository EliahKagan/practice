# LeetCode #653 - Two Sum IV - Input is a BST
# https://leetcode.com/problems/two-sum-iv-input-is-a-bst/
# By repeatedly searching the BST. Runtime is O(size * height).

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
# @param {Integer} target
# @return {Boolean}
def find_target(root, target)
  each_val(root) { |val| return true if bst_has?(root, target - val) }
  false
end

def each_val(root)
  return unless root

  each_val(root.left) { |val| yield val }
  yield root.val
  each_val(root.right) { |val| yield val }

  nil
end

def bst_has?(root, val)
  while root
    return true if val == root.val
    root = (val < root.val ? root.left : root.right)
  end

  false
end
