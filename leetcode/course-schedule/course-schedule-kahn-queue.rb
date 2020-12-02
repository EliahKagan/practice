# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Boolean}
def can_finish(num_courses, prerequisites)
  !Graph.new(num_courses, prerequisites).cyclic?
end

class Graph
  def initialize(vertex_count, edges)
    @adj = Array.new(vertex_count) { [] }.freeze
    @indegrees = [0] * vertex_count

    edges.each do |src, dest|
      @adj[src] << dest
      @indegrees[dest] += 1
    end

    @adj.each &:freeze
    @indegrees.freeze
  end

  def cyclic?
    count = @adj.size
    indegs = @indegrees.dup
    fringe = roots

    until fringe.empty?
      count -= 1

      @adj[fringe.shift].each do |dest|
        indegs[dest] -= 1
        fringe.push(dest) if indegs[dest].zero?
      end
    end

    count.positive?
  end

  private def roots
    @indegrees
      .lazy
      .with_index
      .filter { |indegree, _vertex| indegree.zero? }
      .map { |_indegree, vertex| vertex }
      .to_a
  end
end
