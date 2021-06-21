# LeetCode #138 - Copy List with Random Pointer
# https://leetcode.com/problems/copy-list-with-random-pointer/
# Interleaving way. (This uses less space than the hashing way, but since it
# temporarily modifies nodes in the input list, it is not thread-safe.)

# Definition for Node.
# class Node
#     attr_accessor :val, :next, :random
#     def initialize(val = 0)
#         @val = val
#		  @next = nil
#		  @random = nil
#     end
# end

# @param {Node} node
# @return {Node}
def copyRandomList(head)
  insert_new_nodes(head)
  set_random_links(head)
  extract_new_nodes(head)
end

# Creates and inserts the image of each node after it in the original list.
def insert_new_nodes(head)
  while head
    nxt = Node.new(head.val)
    nxt.next = head.next
    head.next = nxt

    head = nxt.next
  end
end

# Sets the "random" pointers in each interleaved image node to its final value.
def set_random_links(head)
  while head
    head.next.random = head.random.next if head.random
    head = head.next.next
  end
end

# Deinterleaves the list, splicing out each image node. Returns the head image.
def extract_new_nodes(head)
  sentinel = Node.new(nil)
  image = sentinel

  while head
    image = image.next = head.next
    head = head.next = head.next.next
  end

  image.next = nil
  sentinel.next
end
