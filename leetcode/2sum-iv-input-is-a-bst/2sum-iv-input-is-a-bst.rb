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
  each_node(root) do |cur|
    other = find(root, target - cur.val)
    return true if other && other != cur
  end

  false
end

def each_node(root)
  return unless root

  each_node(root.left) { |node| yield node }
  yield root
  each_node(root.right) { |node| yield node }

  nil
end

def find(root, val)
  while root
    return root if val == root.val
    root = (val < root.val ? root.left : root.right)
  end

  nil
end
