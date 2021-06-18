# LeetCode #589 - N-ary Tree Preorder Traversal
# https://leetcode.com/problems/n-ary-tree-preorder-traversal/
# Simple recursive solution.

# Definition for a Node.
# class Node
#     attr_accessor :val, :children
#     def initialize(val)
#         @val = val
#         @children = []
#     end
# end

# @param {Node} root
# @return {List[int]}
def preorder(root)
  out = []

  dfs = ->(node) do
    out << node.val
    node.children.each(&dfs)
  end

  dfs.call(root) if root
  out
end
