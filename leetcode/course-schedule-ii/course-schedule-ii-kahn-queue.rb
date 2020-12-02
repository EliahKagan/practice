# @param {Integer} num_courses
# @param {Integer[][]} prerequisites
# @return {Integer[]}
def find_order(num_courses, prerequisites)
  Graph.new(num_courses, transpose_edges(prerequisites)).toposort || []
end

def transpose_edges(edges)
  edges.lazy.map { |src, dest| [dest, src] }
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

  def toposort
    out = []
    indegs = @indegrees.dup
    fringe = roots

    until fringe.empty?
      src = fringe.shift
      out << src

      @adj[src].each do |dest|
        indegs[dest] -= 1
        fringe.push(dest) if indegs[dest].zero?
      end
    end

    out.size == @adj.size ? out : nil
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
