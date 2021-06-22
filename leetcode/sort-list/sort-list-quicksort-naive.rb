# LeetCode #148 - Sort List
# https://leetcode.com/problems/sort-list/
# By quicksort, first-element pivot selection. This doesn't have any performance
# advantage over mergesort for linked lists, and it has worst-case O(N^2)
# runtime. This happens on sorted lists, due to the naive pivot selection. (For
# that reason, this implemntation exceeds the LeetCode time limit.)

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode} head
# @return {ListNode}
def sort_list(head)
  return head unless head && head.next

  lt_head, eq_head, gt_head = partition(head, head.val)
  concat(sort_list(lt_head), eq_head, sort_list(gt_head))
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
