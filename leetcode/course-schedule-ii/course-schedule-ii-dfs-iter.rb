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

    # Returns true on success, false on failure due to cycle.
    dfs = ->(start) do
      return true if vis[start] == :black
      raise 'Bug: corrupted visitation state' unless vis[start] == :white
      vis[start] = :gray
      stack = [Frame.new(start)]

      until stack.empty?
        frame = stack.last
        row = @adj[frame.src]

        if frame.index == row.size
          out << frame.src
          vis[frame.src] = :black
          stack.pop
          next
        end

        dest = row[frame.index]
        frame.index += 1

        case vis[dest]
        when :white
          vis[dest] = :gray
          stack.push(Frame.new(dest))
        when :gray
          return false
        when :black
          next
        else
          raise 'unrecognized visitation state'
        end
      end

      true
    end

    (0...@adj.size).all?(&dfs) ? out : nil
  end
end

class Frame
  attr_reader :src
  attr_accessor :index

  def initialize(src)
    @src = src
    @index = 0
  end
end
