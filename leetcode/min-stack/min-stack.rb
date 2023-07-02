# LeetCode #155 - Min Stack
# https://leetcode.com/problems/min-stack/

# A stack that keeps track of the minimum value stored in it.
class MinStack
  def initialize
    @elems = []
    @mins = []
  end

=begin
  :type val: Integer
  :rtype: Void
=end
  def push(val)
    @elems << val
    @mins << [get_min || Float::INFINITY, val].min
    nil
  end

=begin
  :rtype: Void
=end
  def pop
    @mins.pop
    @elems.pop
  end

=begin
  :rtype: Integer
=end
  def top
    @elems.last
  end

=begin
  :rtype: Integer
=end
  def get_min
    @mins.last
  end
end

# Your MinStack object will be instantiated and called as such:
# obj = MinStack.new()
# obj.push(val)
# obj.pop()
# param_3 = obj.top()
# param_4 = obj.get_min()
