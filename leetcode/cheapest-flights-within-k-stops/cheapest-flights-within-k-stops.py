# LeetCode #787 - Cheapest Flights Within K Stops
# https://leetcode.com/problems/cheapest-flights-within-k-stops/
# Via BFS with relaxations (compare to Dijkstra's algorithm).

class Solution:
    @staticmethod
    def findCheapestPrice(n: int,
                          flights: List[List[int]],
                          src: int,
                          dst: int,
                          k: int) -> int:
        graph = Graph(n)
        for src, dest, weight in flights:
            graph.add_edge(src, dest, weight)

        min_cost = graph.min_path_cost(src, dst, k + 1)
        return -1 if min_cost == math.inf else min_cost


class Graph:
    """A weighted directed graph."""

    __slots__ = ('_adj',)

    def __init__(self, vertex_count):
        self._adj = [[] for _ in range(vertex_count)]

    def add_edge(self, src, dest, weight):
        self._check(src)
        self._check(dest)
        self._adj[src].append((dest, weight))

    def min_path_cost(self, start, finish, max_depth):
        print(f'start={start}, finish={finish}')
        self._check(start)
        self._check(finish)

        costs = [math.inf] * self._vertex_count
        queue = collections.deque()
        costs[start] = 0
        queue.append((start, 0))

        for _ in range(max_depth):
            if not queue:
                break

            for _ in range(len(queue)):
                print(queue)
                src, src_cost = queue.popleft()

                for dest, weight in self._adj[src]:
                    dest_cost = src_cost + weight
                    if costs[dest] <= dest_cost:
                        continue

                    costs[dest] = dest_cost
                    queue.append((dest, dest_cost))

        return costs[finish]

    @property
    def _vertex_count(self):
        return len(self._adj)

    def _check(self, vertex):
        if not 0 <= vertex < self._vertex_count:
            raise ValueError('vertex out of range')
