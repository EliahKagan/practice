# LeetCode #572 - Subtree of Another Tree
# https://leetcode.com/problems/subtree-of-another-tree/
# By hashing, linear O(M + N) runtime, implemented recursively.

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

  add = lambda do |node|
    return 0 unless node

    table[[node.val, add.call(node.left), add.call(node.right)]] ||=
        table.size + 1
  end

  find = lambda do |node|
    return 0 unless node

    table[[node.val, find.call(node.left), find.call(node.right)]]
  end

  add.call(root)
  !!find.call(sub_root)
end
