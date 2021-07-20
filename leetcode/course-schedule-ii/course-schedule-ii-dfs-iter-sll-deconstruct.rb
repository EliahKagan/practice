# LeetCode #210 - Course Schedule II
# https://leetcode.com/problems/course-schedule-ii/
# By iterative DFS, removing edges, creating a singly linked list.

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
    @adj = Array.new(vertex_count) { [] }
  end

  def add_edge(src, dest)
    raise 'vertex out of range' unless exists?(src) && exists?(dest)
    @adj[src] << dest
  end

  # Uses DFS to find a topological sort if there is one. Deconstructs the
  # graph, removing edges as they are traversed. Returns nil if a cycle is
  # found.
  def deconstruct_to_toposort
    sentinel = Node.new(nil, nil)
    vis = [:white] * vertex_count

    dfs = proc do |node|
      vis[node.value] = :gray
      stack = [node]

      until stack.empty?
        node = stack.last
        src = node.value

        if (dest = @adj[src].shift).nil?
          vis[src] = :black
          stack.pop
          next
        end

        case vis[dest]
        when :white
          vis[dest] = :gray
          stack << Node.new(node, dest)
        when :gray
          return nil
        when :black
          next
        else
          raise 'unrecognized visitation state'
        end
      end
    end

    (0...vertex_count).each do |start|
      dfs.call(Node.new(sentinel, start)) if vis[start] == :white
    end

    sentinel.next
  end

  private

  def vertex_count
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end

# A node in a singly linked list.
class Node
  include Enumerable

  attr_reader :value, :next

  def initialize(prev, value)
    @value = value

    if prev
      @next = prev.next
      prev.next = self
    else
      @next = nil
    end
  end

  def each
    node = self

    while node
      yield node.value
      node = node.next
    end
  end

  protected

  attr_writer :next
end
