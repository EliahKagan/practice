# LeetCode #332 - Reconstruct Itinerary
# https://leetcode.com/problems/reconstruct-itinerary/
# By Hierholzer's algorithm, recursively building an array in reverse.

# @param {String[][]} tickets
# @return {String[]}
def find_itinerary(tickets)
  adj = build_adjacency_list(tickets)
  out = []

  dfs = lambda do |src|
    if (neighbors = adj[src])
      dfs.call(neighbors.shift) until neighbors.empty?
    end

    out << src
  end

  dfs.call('JFK').reverse!
end

def build_adjacency_list(tickets)
  adj = {}
  tickets.each { |src, dest| (adj[src] ||= []) << dest }
  adj.each_value(&:sort!)
  adj
end
