# LeetCode #23 - Merge k Sorted Lists
# https://leetcode.com/problems/merge-k-sorted-lists/
# Using a custom binary minheap priority queue.

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
  heap = MinNodeHeap.new(lists)

  until heap.empty?
    head = heap.pop
    pre = pre.next = head
    heap.push(head.next) if head.next
  end

  pre.next = nil
  sentinel.next
end

# A binary-heap min priority queue comparing list nodes by value.
class MinNodeHeap
  def initialize(heads)
    @heap = heads.compact
    heapify
  end

  def empty?
    @heap.empty?
  end

  def size
    @heap.size
  end

  def push(node)
    sift_up(size, node)
  end

  def pop
    case size
    when 0
      raise "can't pop from empty heap"
    when 1
      @heap.pop
    else
      ret = @heap[0]
      sift_down(0, @heap.pop)
      ret
    end
  end

  private

  def heapify
    (size / 2 - 1).downto(0) { |parent| sift_down(parent, @heap[parent]) }
  end

  def sift_up(child, child_node)
    until child.zero?
      parent = (child - 1) / 2
      break unless child_node.val < @heap[parent].val

      @heap[child] = @heap[parent]
      child = parent
    end

    @heap[child] = child_node
    nil
  end

  def sift_down(parent, parent_node)
    loop do
      child = pick_child(parent)
      break unless child && @heap[child].val < parent_node.val

      @heap[parent] = @heap[child]
      parent = child
    end

    @heap[parent] = parent_node
    nil
  end

  def pick_child(parent)
    left = parent * 2 + 1
    return nil if left >= size

    right = left + 1
    right != size && @heap[right].val < @heap[left].val ? right : left
  end
end
