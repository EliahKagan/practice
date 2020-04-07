# Rust & Murderer

https://www.hackerrank.com/challenges/rust-murderer

# Strategy Used

Cities are vertices. Major roads are edges in an original graph. Back roads are edges in its complement graph.

1. Populate an adjacency list for the original graph. Rather than building the complement graph, perform traversals using this adjacency list, where each row is regarded to specify *non*-neighbors.

2. Track costs, vistation state, and which (and how many) vertices have not yet been found by traversing edges in the complement graph.

3. Traverse the complement graph breadth-first until all vertices are seen.

4. Return the costs, to be reported to the user.

For step 2, costs and vistation state can be stored in a one vertex-indexed array in which a special value indicates that no path to a vertex has yet been found. (Conceptually this value represent infinity.) This is analogous to a common approach to implementing Dijkstra's algorithm, though that algorithm is not needed (and shouldn't be used) here, since all edges have the same weight.

The number of remaining destinaton vertices can be stored in a counter that is decremented, or a data structure of destinations that have not yet been found (i.e., whose costs have not yet been recorded) in which a vertex can be removed in O(1) time without interrupting iteration can be used.
