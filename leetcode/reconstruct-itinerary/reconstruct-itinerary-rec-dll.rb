# LeetCode #332 - Reconstruct Itinerary
# https://leetcode.com/problems/reconstruct-itinerary/
# By Hierholzer's algorithm, recursively building a doubly linked list.

# @param {String[][]} tickets
# @return {String[]}
def find_itinerary(tickets)
  adj = build_adjacency_list(tickets)
  start = Node.new(nil, 'JFK')

  dfs = lambda do |node|
    neighbors = adj[node.value]
    return unless neighbors

    dfs.call(Node.new(node, neighbors.shift)) until neighbors.empty?
  end

  dfs.call(start)
  start.to_a
end

def build_adjacency_list(tickets)
  adj = {}
  tickets.each { |src, dest| (adj[src] ||= []) << dest }
  adj.each_value(&:sort!)
  adj
end

# A doubly linked list node.
class Node
  include Enumerable

  attr_reader :prev, :next, :value

  def initialize(prev, value)
    if prev
      @prev = prev
      @next = prev.next

      @prev.next = self
      @next.prev = self if @next
    else
      @prev = @next = nil
    end

    @value = value
  end

  def each
    node = self

    while node
      yield node.value
      node = node.next
    end
  end

  protected

  attr_writer :prev, :next
end
