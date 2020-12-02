# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Integer[]}
def find_order(num_courses, prerequisites)
  Graph.new(num_courses, prerequisites).reverse_toposort || []
end

class Graph
  def initialize(vertex_count, edges)
    @adj = Array.new(vertex_count) { [] }
    edges.each { |src, dest| @adj[src] << dest }
  end

  def reverse_toposort
    out = []
    vis = [:white] * @adj.size

    dfs = ->(src) do # Returns true on success, false on failure due to cycle.
      case vis[src]
      when :white
        vis[src] = :gray
        return false unless @adj[src].all?(&dfs)
        out << src
        vis[src] = :black
        true
      when :gray
        false
      when :black
        true
      else
        raise 'Bug: unrecognized visitation state'
      end
    end

    (0...@adj.size).all?(&dfs) ? out : nil
  end
end
