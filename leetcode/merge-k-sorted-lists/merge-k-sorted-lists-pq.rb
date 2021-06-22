# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Using a binary minheap priority queue.

# Definition for singly-linked list.
# class ListNode
#     attr_accessor :val, :next
#     def initialize(val = 0, _next = nil)
#         @val = val
#         @next = _next
#     end
# end
# @param {ListNode[]} lists
# @return {ListNode}
def merge_k_lists(lists)
  pre = sentinel = ListNode.new

  heap = PriorityQueue.make_minheap_by(&:val)
  lists.each { |head| heap.push(head) if head }

  until heap.empty?
    head = heap.pop
    pre = pre.next = head
    heap.push(head.next) if head.next
  end

  pre.next = nil
  sentinel.next
end

# Array extension for swapping elements.
class Array
  def swap(index1, index2)
    self[index1], self[index2] = self[index2], self[index1]
  end
end

# Signals an invalid operation on a PriorityQueue.
class PriorityQueueError < IndexError
end

# A priority queue implemented as a binary heap. With <=>, this is a minheap.
class PriorityQueue
  def self.make_minheap_by
    PriorityQueue.new { |ls, rs| yield(ls) <=> yield(rs) }
  end

  def initialize(&block)
    @comparer = block
    @elems = []
  end

  def empty?
    @elems.empty?
  end

  def size
    @elems.size
  end

  def push(key)
    @elems << key
    sift_up(size - 1)
  end

  def top
    ret = @elems[0]
    return ret if ret

    raise PriorityQueueError, "can't read top of empty priority queue"
  end

  def pop
    ret = top
    if @elems.one?
      @elems.clear
    else
      @elems[0] = @elems.pop
      sift_down(0)
    end
    ret
  end

  private

  def sift_up(child)
    until child.zero?
      parent = (child - 1) / 2
      break if order_ok?(parent, child)

      @elems.swap(parent, child)
      child = parent
    end
  end

  def sift_down(parent)
    loop do
      child = pick_child(parent)
      break if child.nil? || order_ok?(parent, child)

      @elems.swap(parent, child)
      parent = child
    end
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right == size || order_ok?(left, right) ? left : right
  end

  def order_ok?(parent, child)
    @comparer.call(@elems[parent], @elems[child]) <= 0
  end
end
