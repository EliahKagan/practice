#!/usr/bin/env python

"""
HackerRank: Breadth First Search: Shortest Reach

https://www.hackerrank.com/challenges/bfsshortreach

Straightforward BFS. With type annotations (to practice using them with
slightly dated versions of Python 3, as in HackerRank's environment).
"""

import collections
import itertools
from typing import Iterable, Optional, MutableSequence, Sequence, TypeVar


T = TypeVar('T')  # pylint: disable=invalid-name


class Graph:
    """An unweighted directed graph."""

    __slots__ = ('_adj',)

    _adj: Sequence[MutableSequence[int]]

    def __init__(self, order: int) -> None:
        """Creates a graph with vertices 1, ..., order, and no edges."""
        self._adj = tuple([] for _ in range(order + 1))

    @property
    def order(self) -> int:
        """The number of vertices in the graph."""
        return len(self._adj) - 1

    def add_edge(self, u: int, v: int) -> None:  # pylint: disable=invalid-name
        """Adds the undirected edge {u, v} to the graph."""
        if not (self._exists(u) and self._exists(v)):
            raise ValueError('edge endpoint out of range')

        self._adj[u].append(v)
        self._adj[v].append(u)

    def bfs(self, start: int) -> list[Optional[int]]:
        """Finds distances to all vertices from a start vertex."""
        if not self._exists(start):
            raise ValueError('start vertex out of range')

        distances: list[Optional[int]] = [None] * (self.order + 1)
        distances[start] = 0
        queue = collections.deque((start,))

        for depth in itertools.count(1):
            if not queue:
                break

            for _ in range(len(queue)):
                for dest in self._adj[queue.popleft()]:
                    if distances[dest] is None:
                        distances[dest] = depth
                        queue.append(dest)

        return distances

    def _exists(self, vertex: int) -> bool:
        """Checks if the vertex is in range (exists in the graph)."""
        return 0 < vertex <= self.order


EDGE_WEIGHT = 6
"""All edges will be (re)interpreted to have this weight."""

UNREACHABLE_DISTANCE = -1
"""The "distance" that will be shown for a vertex that is unreachable."""


def read_value() -> int:
    """Reads a line as a single integer."""
    return int(input())


def read_record() -> Iterable[int]:
    """Reads a line as (potentially) multiple integers."""
    return map(int, input().split())


def without_indices(values: Sequence[T], indices: Sequence[int]) \
        -> Iterable[T]:
    """
    Returns a iterable of the given values, except those at the given indices.
    """
    return (value for index, value in enumerate(values)
            if index not in indices)


def get_output_distance(depth: Optional[int]) -> int:
    """Processes a BFS depth into a distance value, for output."""
    return UNREACHABLE_DISTANCE if depth is None else depth * EDGE_WEIGHT


def run() -> None:
    """Reads queries and outputs their solutions."""
    for _ in range(read_value()):
        vertex_count, edge_count = read_record()
        graph = Graph(vertex_count)
        for _ in range(edge_count):
            graph.add_edge(*read_record())
        start = read_value()
        depths = graph.bfs(start)
        print(*map(get_output_distance, without_indices(depths, (0, start))))


if __name__ == '__main__':
    run()
