# LeetCode #1129 - Shortest Path with Alternating Colors
# https://leetcode.com/problems/shortest-path-with-alternating-colors/
# By BFS on a doubled bipartite graph.

NO_PATH = -1


class Solution:
    @staticmethod
    def shortestAlternatingPaths(n: int,
                                 red_edges: List[List[int]],
                                 blue_edges: List[List[int]]) -> List[int]:
        bipartite_distances = build_graph(n, red_edges, blue_edges).bfs(0, n)
        zipped = zip(bipartite_distances[:n], bipartite_distances[n:])
        return [minimum_or_no_path(lhs, rhs) for lhs, rhs in zipped]


def build_graph(n, red_edges, blue_edges):
    graph = Graph(n * 2)

    for src, dest in red_edges:
        if not 0 <= src < n:
            raise ValueError('red-edge source out of range')
        if not 0 <= dest < n:
            raise ValueError('red-edge destination out of range')

        graph.add_edge(src, n + dest)

    for src, dest in blue_edges:
        if not 0 <= src < n:
            raise ValueError('blue-edge source out of range')
        if not 0 <= dest < n:
            raise ValueError('blue-edge destination out of range')

        graph.add_edge(n + src, dest)

    return graph


def minimum_or_no_path(lhs, rhs):
    if lhs is None and rhs is None:
        return NO_PATH
    if lhs is None:
        return rhs
    if rhs is None:
        return lhs
    return min(lhs, rhs)


class Graph:
    """
    An unweighted directed graph supporting multi-source BFS to all vertices.
    """

    __slots__ = ('_adj',)

    def __init__(self, order):
        self._adj = [[] for _ in range(order)]

    @property
    def order(self):
        return len(self._adj)

    def add_edge(self, src, dest):
        if not (self._exists(src) and self._exists(dest)):
            raise ValueError('endpoint out of range')

        self._adj[src].append(dest)

    def bfs(self, *sources):
        if not all(self._exists(src) for src in sources):
            raise ValueError('source out of range')

        costs = [None] * self.order
        for src in sources:
            costs[src] = 0

        queue = collections.deque(sources)

        for depth in itertools.count(1):
            if not queue:
                return costs

            for _ in range(len(queue)):
                for dest in self._adj[queue.popleft()]:
                    if costs[dest] is not None:
                        continue

                    costs[dest] = depth
                    queue.append(dest)

    def _exists(self, vertex):
        return 0 <= vertex < self.order
