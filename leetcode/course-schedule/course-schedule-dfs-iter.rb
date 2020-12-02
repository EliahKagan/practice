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

    cyclic_from = ->(start) do
      return false if vis[start] == :black
      raise 'corrupted visitation state' unless vis[start] == :white
      vis[start] = :gray
      stack = [Frame.new(start)]

      until stack.empty?
        frame = stack.last
        row = @adj[frame.src]

        if frame.index == row.size
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
          return true
        when :black
          next
        else
          raise 'unrecognized visitation state'
        end
      end
    end

    (0...@adj.size).any?(&cyclic_from)
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
