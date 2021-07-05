# LeetCode #297 - Serialize and Deserialize Binary Tree
# https://leetcode.com/problems/serialize-and-deserialize-binary-tree/
# Recursive postorder traversal serialization.
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
  tokens = []

  dfs = lambda do |node|
    if node
      dfs.call(node.left)
      dfs.call(node.right)
      tokens << node.val
    else
      tokens << '.'
    end
  end

  dfs.call(root)
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
