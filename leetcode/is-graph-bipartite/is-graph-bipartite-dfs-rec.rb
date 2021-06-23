# LeetCode #785 - Is Graph Bipartite?
# https://leetcode.com/problems/is-graph-bipartite/
# By recursive DFS.

# @param {Integer[][]} graph
# @return {Boolean}
def is_bipartite(graph)
  vis = [nil] * graph.size

  is_bipartite_from = lambda do |src, src_color|
    return vis[src] == src_color if vis[src]

    vis[src] = src_color
    dest_color = neighbor_color(src_color)
    graph[src].all? { |dest| is_bipartite_from.call(dest, dest_color) }
  end

  (0...graph.size).all? do |start|
    vis[start] || is_bipartite_from.call(start, :red)
  end
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
