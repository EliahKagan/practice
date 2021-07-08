# LeetCode #332 - Reconstruct Itinerary
# https://leetcode.com/problems/reconstruct-itinerary/
# By Hierholzer's algorithm, iteratively building an array in reverse.

# @param {String[][]} tickets
# @return {String[]}
def find_itinerary(tickets)
  adj = build_adjacency_list(tickets)
  out = []
  stack = ['JFK']

  until stack.empty?
    if (dest = adj[stack.last]&.shift)
      stack << dest
    else
      out << stack.pop
    end
  end

  out.reverse!
end

def build_adjacency_list(tickets)
  adj = {}
  tickets.each { |src, dest| (adj[src] ||= []) << dest }
  adj.each_value(&:sort!)
  adj
end
