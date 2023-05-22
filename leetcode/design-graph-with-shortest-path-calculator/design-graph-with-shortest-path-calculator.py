# LeetCode #2694 - Design Graph With Shortest Path Calculator
# https://leetcode.com/problems/design-graph-with-shortest-path-calculator/
# Via Dijkstra's algorithm, using a standard library binary minheap (heapq).

class Graph:
    """Weighted directed graph. Supports computing shorest paths."""

    __slots__ = ('_adj',)

    NO_PATH = -1

    _adj: List[List[int]]

    def __init__(self, n: int, edges: List[List[int]]) -> None:
        """Create a graph with nodes 0, ... n - 1 and given initial edges."""
        self._adj = [[] for _ in range(n)]

        for edge in edges:
            self.addEdge(edge)

    def addEdge(self, edge: List[int]) -> None:
        """Add an edge to the graph."""
        node1, node2, weight = edge
        self._adj[node1].append((node2, weight))

    def shortestPath(self, node1: int, node2: int) -> int:
        """Compute the shortest path from node1 to node2."""
        done = [False] * len(self._adj)
        costs = [None] * len(self._adj)
        costs[node1] = 0
        pq = [(0, node1)]

        while pq:
            src_cost, src = heapq.heappop(pq)
            if done[src]:
                continue
            if src == node2:
                return src_cost

            done[src] = True
            costs[src] = src_cost

            for dest, weight in self._adj[src]:
                if done[dest]:
                    continue
                new_dest_cost = src_cost + weight
                if costs[dest] is not None and costs[dest] <= new_dest_cost:
                    continue
                costs[dest] = new_dest_cost
                heapq.heappush(pq, (new_dest_cost, dest))

        return self.NO_PATH


# Your Graph object will be instantiated and called as such:
# obj = Graph(n, edges)
# obj.addEdge(edge)
# param_2 = obj.shortestPath(node1,node2)
