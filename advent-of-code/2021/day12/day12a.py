#!/usr/bin/env python

"""Advent of Code, day 12, part A"""

import collections
import fileinput
from typing import Mapping, Sequence


def big(vertex: str):
    """Checks if the first letter of a vertex name is capitalized."""
    try:
        return vertex[0].isupper()
    except IndexError as error:
        raise ValueError('empty vertex name not supported') from error


class Maze:
    """A custom undirected graph for the maze traversal problem."""

    __slots__ = ('_adj',)

    _adj: Mapping[str, Sequence[str]]

    def __init__(self):
        """Creates a new, initially empty maze."""
        self._adj = collections.defaultdict(list)

    def add_edge(self, u: str, v: str) -> None:
        """Adds an edge (a maze passage) between u and v."""
        if big(u) and big(v):
            raise ValueError(f'adjacent "big" vertices {u!r}, {v!r} produce '
                             'infinitely many paths')

        self._adj[u].append(v)
        self._adj[v].append(u)

    def count_paths(self, start: str = 'start', end: str = 'end') -> int:
        """
        Counts the number of paths from a start to a finish vertex.

        These paths are permitted to visit each "big" (initially capitalized)
        vertex at most once.
        """
        vis = set()

        def dfs(src: str) -> int:
            if src == end:
                return 1
            if src in vis:
                return 0
            if not big(src):
                vis.add(src)
            count = sum(map(dfs, self._adj[src]))
            if not big(src):
                vis.remove(src)
            return count

        return dfs(start)


def run() -> None:
    """Reads a maze from stdin or a file and reports a permitted path count."""
    maze = Maze()

    for u, v in (line.strip().split('-') for line in fileinput.input()):
        maze.add_edge(u, v)

    print(maze.count_paths())


if __name__ == '__main__':
    run()
