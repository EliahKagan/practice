#!/usr/bin/env python

"""Advent of Code 2021, day 12, part B"""

import collections
import fileinput
from typing import Iterable, Mapping, MutableSequence

from typeguard import typechecked


def big(vertex: str):
    """
    Checks if the first letter of a vertex name is capitalized.

    This is not @typechecked, since that had a huge performance impact.
    """
    try:
        return vertex[0].isupper()
    except IndexError as error:
        raise ValueError('empty vertex name not supported') from error


@typechecked
class Maze:
    """A custom undirected graph for the maze traversal problem."""

    __slots__ = ('_adj',)

    _adj: Mapping[str, MutableSequence[str]]

    def __init__(self) -> None:
        """Creates a new, initially empty maze."""
        self._adj = collections.defaultdict(list)

    def add_edge(self, u: str, v: str) -> None:  # pylint: disable=invalid-name
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
        revis = None

        def dfs(src: str) -> int:
            nonlocal revis

            if src == end:
                return 1

            if not big(src):
                if src not in vis:
                    vis.add(src)
                elif revis is None and src != start:
                    revis = src
                else:
                    return 0

            count = sum(map(dfs, self._adj[src]))

            if not big(src):
                if src == revis:
                    revis = None
                else:
                    vis.remove(src)

            return count

        return dfs(start)


@typechecked
def run() -> None:
    """Reads a maze from stdin or a file and reports a permitted path count."""
    maze = Maze()

    lines: Iterable[str] = fileinput.input()

    # pylint: disable=invalid-name
    for u, v in (line.strip().split('-') for line in lines):
        maze.add_edge(u, v)

    print(maze.count_paths())


if __name__ == '__main__':
    run()
