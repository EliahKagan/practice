# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By iteratively implemented quicksort, middle-element pivot selection.
# Quicksort doesn't have any performance advantage over mergesort for linked
# lists, and it has worst-case O(N^2) runtime. On an array, quicksort is easy
# to implement iteratively (structurally it is analogous to preorder traversal
# of a binary tree). Here, I'm joining the sublists after partitioning, so an
# iterative implementation is more involved.

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end

class Frame < Struct.new(:head, :lt_head, :eq_head, :gt_head, :state)
  def initialize(head)
    super(head, nil, nil, nil, :check_head)
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
        frame.lt_head, frame.eq_head, frame.gt_head =
            partition(frame.head, middle(frame.head).val)
        frame.state = :collect_left
        stack << Frame.new(frame.lt_head)
      else
        head = frame.head
        stack.pop
      end
    when :collect_left
      frame.lt_head = head
      frame.state = :collect_right
      stack << Frame.new(frame.gt_head)
    when :collect_right
      head = concat(frame.lt_head, frame.eq_head, head)
      stack.pop
    end
  end

  head
end

def middle(head)
  raise 'refusing to find the middle of an empty list' unless head

  fast = head
  while fast && fast.next
    head = head.next
    fast = fast.next.next
  end

  head
end

def partition(head, pivot)
  lt_pre = lt_sentinel = ListNode.new
  eq_pre = eq_sentinel = ListNode.new
  gt_pre = gt_sentinel = ListNode.new

  while head
    if head.val < pivot
      lt_pre = lt_pre.next = head
    elsif head.val > pivot
      gt_pre = gt_pre.next = head
    else
      eq_pre = eq_pre.next = head
    end

    head = head.next
  end

  lt_pre.next = eq_pre.next = gt_pre.next = nil
  [lt_sentinel.next, eq_sentinel.next, gt_sentinel.next]
end

def concat(*heads)
  raise 'refusing to concatenate zero lists' if heads.empty?

  heads.compact!
  raise 'refusing to concatenate all empty lists' if heads.empty?

  *some, last = heads
  pre = sentinel = ListNode.new

  some.each do |head|
    pre.next = head
    pre = pre.next while pre.next
  end

  pre.next = last
  sentinel.next
end
