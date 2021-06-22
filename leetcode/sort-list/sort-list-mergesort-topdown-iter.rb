# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By iteratively implemented recursive top-down mergesort. Uses O(log N) extra
# space (for a stack data structure that simulates a call stack). The state
# machine implements the same logic as in sort-list-mergesort-topdown-rec.rb.

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end

class Frame < Struct.new(:head, :left, :right, :state)
  def initialize(head)
    super(head, nil, nil, :check_head)
  end
end

# @param {ListNode} head
# @return {ListNode}
def sort_list(head)
  stack = [Frame.new(head)]

  until stack.empty?
    frame = stack.last

    case frame.state
    when :check_head
      if frame.head && frame.head.next
        frame.left, frame.right = split(frame.head)
        frame.state = :collect_left
        stack << Frame.new(frame.left)
      else
        head = frame.head
        stack.pop
      end
    when :collect_left
      frame.left = head
      frame.state = :collect_right
      stack << Frame.new(frame.right)
    when :collect_right
      head = merge(frame.left, head)
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
