# LeetCode #210 - Course Schedule II
# https://leetcode.com/problems/course-schedule-ii/
# By recursive DFS, removing edges as they are traversed.

# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Integer[]}
def find_order(num_courses, prerequisites)
  build_graph(num_courses, prerequisites).deconstruct_to_reverse_toposort || []
end

def build_graph(vertex_count, edges)
  graph = Graph.new(vertex_count)
  edges.each { |src, dest| graph.add_edge(src, dest) }
  graph
end

# An unweighted directed graph with a destructive reverse-toposort operation.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def add_edge(src, dest)
    raise 'vertex out of range' unless exists?(src) && exists?(dest)
    @adj[src] << dest
  end

  # Uses DFS to find a reverse topological sort if there is one. Deconstructs
  # the graph, removing edges as they are traversed. Returns nil if a cycle is
  # found.
  def deconstruct_to_reverse_toposort
    out = []
    vis = [:white] * vertex_count

    dfs = proc do |src|
      case vis[src]
      when :white
        vis[src] = :gray
        while (dest = @adj[src].shift)
          dfs.call(dest)
        end
        vis[src] = :black
        out << src

      when :gray
        return nil

      when :black
        next

      else
        raise "unrecognized visitation state #{vis[src]}"
      end
    end

    (0...vertex_count).each(&dfs)
    out
  end

  private

  def vertex_count
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end
