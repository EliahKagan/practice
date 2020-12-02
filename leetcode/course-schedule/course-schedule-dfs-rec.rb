# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Boolean}
def can_finish(num_courses, prerequisites)
  !Graph.new(num_courses, prerequisites).cyclic?
end

class Graph
  def initialize(vertex_count, edges)
    @adj = Array.new(vertex_count) { [] }
    edges.each { |src, dest| @adj[src] << dest }
  end

  def cyclic?
    vis = [:white] * @adj.size

    cyclic_from = ->(src) do
      case vis[src]
      when :white
        vis[src] = :gray
        return true if @adj[src].any?(&cyclic_from)
        vis[src] = :black
        false
      when :gray
        true
      when :black
        false
      else
        raise 'Bug: unrecognized visitation state'
      end
    end

    (0...@adj.size).any?(&cyclic_from)
  end
end
