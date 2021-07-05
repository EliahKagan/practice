# LeetCode #297 - Serialize and Deserialize Binary Tree
# https://leetcode.com/problems/serialize-and-deserialize-binary-tree/
# Iterative postorder traversal serialization.
# Stack-based RPN-calculator deserialization.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val)
#         @val = val
#         @left, @right = nil, nil
#     end
# end

# Encodes a tree to a single string.
#
# @param {TreeNode} root
# @return {string}
def serialize(root)
  return '.' unless root

  tokens = []
  stack = []
  post = nil

  while root || !stack.empty?
    # Go left as far as possible.
    while root
      stack << root
      root = root.left
    end

    cur = stack.last
    tokens << '.' unless cur.left

    if cur.right && cur.right != post
      # We can go right, but haven't. Do that next.
      root = cur.right
    else
      # We can't go right or already did. Do the postorder action and retreat.
      tokens << '.' unless cur.right
      tokens << cur.val
      post = cur
      stack.pop
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
