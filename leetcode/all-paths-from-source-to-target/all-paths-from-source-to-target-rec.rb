# LeetCode #797 - All Paths From Source to Target
# https://leetcode.com/problems/all-paths-from-source-to-target/
# Simple recursive backtracking solution.

# @param {Integer[][]} graph
# @return {Integer[][]}
def all_paths_source_target(graph)
  all_paths = []
  path = []
  vis = [false] * graph.size
  finish = graph.size - 1

  dfs = lambda do |src|
    return if vis[src]

    vis[src] = true
    path << src

    if src == finish
      all_paths << path.dup
    else
      graph[src].each(&dfs)
    end

    path.pop
    vis[src] = false
  end

  dfs.call(0)
  all_paths
end
