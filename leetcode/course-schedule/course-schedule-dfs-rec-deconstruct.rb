# LeetCode #207 - Course Schedule
# https://leetcode.com/problems/course-schedule/
# By recursive DFS, removing edges as they are traversed.

# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Boolean}
def can_finish(num_courses, prerequisites)
  !build_graph(num_courses, prerequisites).cyclic?
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

  # Use DFS to check if the graph has a cycle. Removes traversed edges.
  def cyclic?
    vis = [:white] * vertex_count

    dfs = proc do |src|
      case vis[src]
      when :white
        vis[src] = :gray
        while (dest = @adj[src].shift)
          dfs.call(dest)
        end
        vis[src] = :black

      when :gray
        return true

      when :black
        next

      else
        raise "unrecognized visitation state #{vis[src]}"
      end
    end

    (0...vertex_count).each(&dfs)
    false
  end

  private

  def vertex_count
    @adj.size
  end

  def exists?(vertex)
    vertex.between?(0, vertex_count - 1)
  end
end
