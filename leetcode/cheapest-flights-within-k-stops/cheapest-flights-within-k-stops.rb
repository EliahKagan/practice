# LeetCode #787 - Cheapest Flights Within K Stops
# https://leetcode.com/problems/cheapest-flights-within-k-stops/
# Via BFS with relaxations (compare to Dijkstra's algorithm).

# @param {Integer} n
# @param {Integer[][]} flights
# @param {Integer} src
# @param {Integer} dst
# @param {Integer} k
# @return {Integer}
def find_cheapest_price(n, flights, src, dst, k)
  min_cost = build_graph(n, flights).min_path_cost(src, dst, k + 1)
  min_cost == Float::INFINITY ? -1 : min_cost
end

def build_graph(vertex_count, edges)
  graph = Graph.new(vertex_count)
  edges.each { |src, dest, weight| graph.add_edge(src, dest, weight) }
  graph
end

# A weighted directed graph.
class Graph
  def initialize(vertex_count)
    @adj = Array.new(vertex_count) { [] }
  end

  def add_edge(src, dest, weight)
    check(src)
    check(dest)
    @adj[src] << [dest, weight]
    nil
  end

  def min_path_cost(start, finish, max_depth)
    check(start)
    check(finish)

    costs = [Float::INFINITY] * vertex_count
    costs[start] = 0
    queue = [[start, 0]]

    max_depth.times do
      break if queue.empty?

      queue.size.times do
        src, src_cost = queue.shift

        @adj[src].each do |dest, weight|
          dest_cost = src_cost + weight
          next if costs[dest] <= dest_cost

          costs[dest] = dest_cost
          queue << [dest, dest_cost]
        end
      end
    end

    costs[finish]
  end

  private

  def vertex_count
    @adj.size
  end

  def check(vertex)
    raise 'vertex out of range' unless vertex.between?(0, vertex_count - 1)
  end
end
