# LeetCode #210 - Course Schedule II
# https://leetcode.com/problems/course-schedule-ii/
# By iterative DFS, removing edges, creating a doubly linked list.

# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Integer[]}
def find_order(num_courses, prerequisites)
  graph = build_transpose_graph(num_courses, prerequisites)
  graph.deconstruct_to_toposort&.to_a || []
end

def build_transpose_graph(vertex_count, edges)
  graph = Graph.new(vertex_count)
  edges.each { |src, dest| graph.add_edge(dest, src) }
  graph
end

# An unweighted directed graph with a destructive toposort operation.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] } << (0...vertex_count).to_a
  end

  def add_edge(src, dest)
    raise 'vertex out of range' unless exists?(src) && exists?(dest)
    @adj[src] << dest
  end

  # Uses DFS to find a topological sort if there is one. Deconstructs the
  # graph, removing edges as they are traversed. Returns nil if a cycle is
  # found.
  def deconstruct_to_toposort
    vis = Array.new(vertex_count, :white) << :gray
    cur = sentinel = Node.new(nil, -1)

    while cur
      src = cur.value

      if (dest = @adj[src].shift).nil?
        vis[src] = :black
        cur = cur.prev
        next
      end

      case vis[dest]
      when :white
        vis[dest] = :gray
        cur = Node.new(cur, dest)
      when :gray
        return nil
      when :black
        next
      else
        raise 'unrecognized visitation state'
      end
    end

    sentinel.next
  end

  private

  def vertex_count
    @adj.size - 1
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end

# A node in a doubly linked list.
class Node
  include Enumerable

  attr_reader :value, :prev, :next

  def initialize(prev, value)
    @value = value
    @prev = prev
    @next = @prev&.next

    @prev.next = self if @prev
    @next.prev = self if @next
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
