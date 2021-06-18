# LeetCode #590 - N-ary Tree Postorder Traversal
# https://leetcode.com/problems/n-ary-tree-postorder-traversal/
# Iteratively implemented solution, by simulating recursion.

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
  stack = []
  stack << Frame.new(root) if root

  until stack.empty?
    if (child = stack.last.next_child)
      stack << Frame.new(child)
    else
      out << stack.pop.node.val
    end
  end

  out
end

# A stack frame for iteratively implemented recursive n-ary tree traversal.
class Frame
  attr_reader :node

  def initialize(node)
    @node = node
    @index = 0
  end

  def next_child
    child = @node.children[@index]
    @index += 1
    child
  end
end
