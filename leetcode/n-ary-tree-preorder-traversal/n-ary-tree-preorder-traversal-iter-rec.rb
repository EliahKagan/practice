# LeetCode #589 - N-ary Tree Preorder Traversal
# https://leetcode.com/problems/n-ary-tree-preorder-traversal/
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
def preorder(root)
  return [] unless root

  out = [root.val]
  stack = [Frame.new(root)]

  until stack.empty?
    if (child = stack.last.next_child)
      out << child.val
      stack << Frame.new(child)
    else
      stack.pop
    end
  end

  out
end

# A stack frame for iteratively implemented recursive n-ary tree traversal.
class Frame
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
