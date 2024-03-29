# LeetCode #785 - Is Graph Bipartite?
# https://leetcode.com/problems/is-graph-bipartite/
# By stack-based search.

# @param {Integer[][]} graph
# @return {Boolean}
def is_bipartite(graph)
  vis = [nil] * graph.size

  is_bipartite_from = lambda do |start|
    stack = [start]

    until stack.empty?
      src = stack.pop
      dest_color = neighbor_color(vis[src])

      graph[src].each do |dest|
        next if vis[dest] == dest_color

        return false if vis[dest]

        vis[dest] = dest_color
        stack << dest
      end
    end

    true
  end

  0.upto(graph.size - 1) do |start|
    next if vis[start]

    vis[start] = :red
    return false unless is_bipartite_from.call(start)
  end

  true
end

def neighbor_color(color)
  case color
  when :red
    :blue
  when :blue
    :red
  else
    raise "no neighbor color for #{color}"
  end
end
