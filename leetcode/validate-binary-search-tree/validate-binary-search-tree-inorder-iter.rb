# LeetCode #98 - Validate Binary Search Tree
# https://leetcode.com/problems/validate-binary-search-tree/
# By iterative inorder traversal.

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
# @return {Boolean}
def is_valid_bst(root)
  acc = -Float::INFINITY
  stack = []

  while root || !stack.empty?
    # Go left as far as possible.
    while root
      stack << root
      root = root.left
    end

    cur = stack.pop

    # We've explored left but not right. Do the inorder action.
    return false unless acc < cur.val
    acc = cur.val

    # If there's a left subtree from here, traverse there next.
    root = cur.right
  end

  true
end
