# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By iteratively implemented recursive top-down mergesort. Uses O(log N) extra
# space (for a stack data structure that simulates a call stack). The state
# machine implements "arm's length" recursion, which is typically undesirable
# (both in terms of performance and readability/maintainability) in code
# actually written using recursive function calls, but which sometimes reduces
# the number of variables and facilitates easier nilability analysis (and
# sometimes improves performance, when the stack data structure is slow) in a
# state machine.

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end

Frame = Struct.new(:left, :right, :state)

# @param {ListNode} head
# @return {ListNode}
def sort_list(head)
  stack = []
  stack << Frame.new(*split(head), :go_left) if head && head.next

  until stack.empty?
    frame = stack.last

    case frame.state
    when :go_left
      if frame.left && frame.left.next
        frame.state = :collect_left
        stack << Frame.new(*split(frame.left), :go_left)
      else
        frame.state = :go_right
      end
    when :collect_left
      frame.state = :go_right
      frame.left = head
    when :go_right
      if frame.right && frame.right.next
        frame.state = :collect_right
        stack << Frame.new(*split(frame.right), :go_left)
      else
        frame.state = :retreat
      end
    when :collect_right
      frame.state = :retreat
      frame.right = head
    when :retreat
      head = merge(frame.left, frame.right)
      stack.pop
    else
      raise "invalid state: #{frame.state}"
    end
  end

  head
end

def split(head)
  raise 'refusing to split empty list' unless head

  slow = head
  fast = head.next
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end

  mid = slow.next
  slow.next = nil
  [head, mid]
end

def merge(first, second)
  sentinel = ListNode.new
  pre = sentinel

  while first && second
    if second.val < first.val
      pre.next = second
      second = second.next
    else
      pre.next = first
      first = first.next
    end
    pre = pre.next
  end

  pre.next = first || second
  sentinel.next
end
