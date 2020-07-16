# Advent of code 2015, part A
# Via bottom-up toposort via Kahn's algorithm. (Cycle checking?)

require "deque"

# Exception thrown when a Graph is in a state that doesn't support a requested
# operation.
class GraphError
end

# Integer-vertex adjacency-list-based digraph, for topological sort.
class Graph(T)
  @adj = Array(Array(Int32)).new
  @indegrees = Array(Int32).new
  @toposort_started = false
  @toposort_finished = false

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
    if @toposort_started
      raise GraphError.new("Topological sort already started")
    end
    @toposort_started = true

    queue = roots

    until queue.empty?
      src = queue.shift

      @adj[src].each do |dest|
        @indegrees[dest] -= 1
        queue.push(dest) if @indegrees[dest].zero?
      end

      yield src
    end

    @toposort_finished = true
  end

  def cycle_vertices
    unless @toposort_finished
      raise GraphError.new("topological sort not finished")
    end

    @indegrees.each_with_index do |indegree, vertex|
      yield vertex unless indegree.zero?
    end
  end

  private def roots
    queue = Deque(Int32).new

    @indegrees.each_with_index do |indegree, vertex|
      queue.push(vertex) if indegree.zero?
    end

    queue
  end
end

# Hashable-vertex adjacency-list-based digraph, for topological sort.
class HashGraph(T)
  @indices_by_key = Hash(T, Int32).new # maps keys to indices
  @keys_by_index = Array(Int32).new # maps indices to keys
  @graph = Graph(T).new # underlying graph whose vertices are indices

  def order
    @graph.order
  end

  def has_vertex?(key)
    @indices_by_key.has_key?(key)
  end

  def add_edge(src, dest)
    @graph.add_edge(index(src), index(dest))
  end

  def toposort
    @graph.toposort { |index| yield @keys_by_index[index] }
  end

  def cycle_vertices
    @graph.cycle_vertices { |index| yield @keys_by_index[index] }
  end

  # Looks up the index for a key, adding it with the next available index if
  # the key does not already identify a vertex in the graph.
  private def index(key)
    index = @indices_by_key[key]?
    return index if index

    index = @graph.make_vertex
    @keys_by_index << key
    @indices_by_key[key] = index

    unless @graph.order == @keys_by_index.size == @indices_by_key.size
      raise "Internal error: #{self.class} seems to have lost a vertex"
    end

    index
  end
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

def as_term(text)
  if (value = text.to_u16?)
    value
  elsif text.starts_with?(/[a-zA-Z]/)
    text
  else
    raise %{term "#{text}" is neither variable nor constant}
  end
end

def as_expression(tokens)
  case tokens.size
  when 1
    as_term(tokens[0])
  when 2
    {UNARIES[tokens[0]], as_term(tokens[1])}
  when 3
    {BINARIES[tokens[1]], as_term(tokens[0]), as_term(tokens[2])}
  else
    raise "malformed expression" # FIXME: Raise specific exception type?
  end
end

def as_single_mapping(parts)
  raise "wrong syntax for mapping" unless parts.size == 2
  {parts[1], as_expression(parts[0].split)}
end

def as_mappings(lines)
  lines.map(&.strip)
       .reject(&.empty?)
       .map(&.split(/\s+->\s+/))
       .map { |parts| as_single_mapping(parts) }
       .to_h
end

def solve(mappings)
  graph = HashGraph(String).new


end
