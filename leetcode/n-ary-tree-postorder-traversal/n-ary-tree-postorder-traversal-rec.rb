# LeetCode #590 - N-ary Tree Postorder Traversal
# https://leetcode.com/problems/n-ary-tree-postorder-traversal/
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
def postorder(root)
  out = []

  dfs = ->(node) do
    node.children.each(&dfs)
    out << node.val
  end

  dfs.call(root) if root
  out
end
