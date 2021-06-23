# LeetCode #785 - Is Graph Bipartite?
# https://leetcode.com/problems/is-graph-bipartite/
# By BFS.

# @param {Integer[][]} graph
# @return {Boolean}
def is_bipartite(graph)
  vis = [nil] * graph.size

  is_bipartite_from = lambda do |start|
    return true if vis[start]

    vis[start] = :red
    dest_color = :blue
    queue = [start]

    until queue.empty?
      queue.size.times do
        graph[queue.shift].each do |dest|
          next if vis[dest] == dest_color

          return false if vis[dest]

          vis[dest] = dest_color
          queue << dest
        end
      end

      dest_color = neighbor_color(dest_color)
    end

    true
  end

  (0...graph.size).all?(&is_bipartite_from)
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
