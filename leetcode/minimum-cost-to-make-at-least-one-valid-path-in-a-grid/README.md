# [Minimum Cost to Make at Least One Valid Path in a Grid](https://leetcode.com/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/)

This can be solved as a least-cost path problem in a weighted directed graph,
using Dijkstra's algorithm.

Edges run in both directions between adjacent cells (using 4-way adjacency). An
edge that is consistent with the arrow in its source cell has weight 0, since
the arrow doesn't have to be changed to traverse it. All other edges have weight
1 since a single arrow in a single cell must change to traverse them.

Since there are no negative edge weights, there is never a benefit to revisiting
a vertex, so the inability to change an arrow more than once (as stated in the
problem description) does not affect the solution.
