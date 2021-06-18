# LeetCode #145 - Binary Tree Postorder Traversal
# https://leetcode.com/problems/binary-tree-postorder-traversal/
# Special case of a general iterative solution.

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
def postorder_traversal(root)
  out = []
  traverse(root, ->(_) { }, ->(_) { }, ->(val) { out << val })
  out
end

def traverse(root, f_pre, f_in, f_post)
  stack = []
  post = nil

  while root || !stack.empty?
    # Go left as far as possible, doing the preorder action.
    while root
      f_pre.call(root.val)
      stack << root
      root = root.left
    end

    cur = stack.last

    if !cur.right || cur.right != post
      # We have not gone right. Do the inorder action.
      f_in.call(cur.val)
    end

    if cur.right && cur.right != post
      # We have not gone right, but we can. Do that next.
      root = cur.right
    else
      # We have gone right, or can't. Do the postorder action and retreat.
      post = cur
      f_post.call(post.val)
      stack.pop
    end
  end

  nil
end
