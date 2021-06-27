# LeetCode #802 - Find Eventual Safe States
# https://leetcode.com/problems/find-eventual-safe-states/
# By recursive DFS.

# @param {Integer[][]} graph
# @return {Integer[]}
def eventual_safe_nodes(graph)
  vis = [:white] * graph.size

  acyclic_from = lambda do |src|
    case vis[src]
    when :white
      vis[src] = :gray

      # Visits every neighbor before checking "all?".
      acyclic = graph[src].map(&acyclic_from).all?

      vis[src] = :black if acyclic
      acyclic

    when :gray
      false

    when :black
      true

    else
      raise 'unrecognized visitation state'
    end
  end

  (0...graph.size).filter(&acyclic_from)
end
