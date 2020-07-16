# Advent of code 2015, part A
# Via bottom-up toposort via Kahn's algorithm. (Cycle checking?)

# Exception thrown when attempting a reentrant or otherwise repeated
# topological sort on a Graph (or a HashGraph, which uses Graph).
class AlreadyToposortingError
  def initialize
    super("Topological sort already started")
  end
end

# Integer-vertex adjacency-list-based digraph, for topological sort.
class Graph(T)
  @adj = Array(Array(Int32)).new
  @indegrees = Array(Int32).new
  @started_toposort = false

  # The number of vertices in the graph.
  def order
    @adj.size
  end

  def has_vertex?(vertex)
    0 <= vertex < order
  end

  def make_vertex
    vertex = @adj.size
    @adj << Array(Int32).new
    @indegrees << 0
    vertex
  end

  def add_edge(src, dest)
    unless has_vertex?(src)
      raise IndexError.new("Nonexistent source vertex #{src}")
    end
    unless has_vertex?(src)
      raise IndexError.new("Nonexistent destination vertex #{dest}")
    end

    @adj[src] << dest
    @indegrees[dest] += 1
  end

  def toposort
    raise AlreadyToposortingError if @started_toposort
    @started_toposort = true

    roots =
  end
end

# Hashable-vertex adjacency-list-based digraph, for topological sort.
class HashGraph(T)
  @indices_by_key = Hash(T, Int32) # maps keys to indices
  @keys_by_index = Array(Int32).new # maps indices to keys
  @graph = Graph(T).new # underlying graph whose vertices are indices

  # FIXME: implement the rest
end


def unary(&block : UInt16 -> UInt16)
  block
end

def binary(&block : (UInt16, UInt16) -> UInt16)
  block
end

UNARIES = {
  "NOT" => unary { |arg| ~arg }
}

BINARIES = {
  "AND" => binary { |arg1, arg2| arg1 & arg2 },
  "OR" => binary { |arg1, arg2| arg1 | arg2 },
  "LSHIFT" => binary { |arg1, arg2| arg1 << arg2 },
  "RSHIFT" => binary { |arg1, arg2| arg1 >> arg2 }
}
