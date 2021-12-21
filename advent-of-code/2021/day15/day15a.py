#!/usr/bin/env python

"""Advent of Code 2021, day 15, part A"""

import argparse
import fileinput
import heapq
import math
import sys

from typing import Any, Generic, Hashable, Iterable, Mapping, Sequence, TypeVar

import attr
import colorama
from typeguard import typechecked


TVertex = TypeVar('TVertex', bound=Hashable)

TCost = TypeVar('TCost', bound=(int | float))


@typechecked
class _PathTree(Generic[TVertex, TCost]):
    """
    Parents and costs tables for reconstructing paths from a single source.
    """

    __slots__ = ('_start', '_parents', '_costs')

    _start: TVertex
    _parents: Mapping[TVertex, TVertex]
    _costs: Mapping[TVertex, TCost]

    def __init__(self,
                 start: TVertex,
                 parents: Mapping[TVertex, TVertex],
                 costs: Mapping[TVertex, TCost]) -> None:
        """Creates a path tree."""
        self._start = start
        self._parents = parents
        self._costs = costs

    @property
    def start(self) -> TVertex:
        """The start (source) vertex that paths in this tree are from."""
        return self._start

    def path_to(self, finish: TVertex) -> list[TVertex]:
        """Returns the path from the shared start to this finish vertex."""
        path = []

        dest = finish
        while dest != self._start:
            path.append(dest)
            try:
                dest = self._parents[dest]
            except KeyError as error:
                message = f'no path to {finish!r} ({dest!r} has no parent)'
                raise KeyError(message) from error

        path.append(self._start)
        path.reverse()
        return path

    def cost_to(self, finish: TVertex) -> TCost:
        """The cost to get from the hared start to this finish vertex."""
        return self._costs[finish]


@typechecked
@attr.s(frozen=True, slots=True, auto_attribs=True)
class PathCostPair(Generic[TVertex, TCost]):
    """A path given as a sequence of vertices, and the cost to traverse it."""
    path: list[TVertex]
    cost: TCost


@typechecked
class Grid:
    """A game board for the path-finding puzzle."""

    __slots__ = ('_rows', '_height', '_width')

    _rows: Sequence[Sequence[int]]
    _height: int
    _width: int

    def __init__(self, rows: Iterable[Iterable[Any]]) -> None:
        """Creates a grid with the given rows."""
        self._rows = tuple(tuple(map(int, row)) for row in rows)
        self._height = len(self._rows)

        if self._height == 0:
            raise ValueError('empty board (no rows) not supported')

        self._width = len(self._rows[0])

        if any(len(row) != self._width for row in self._rows):
            raise ValueError('jagged board not supported')

        if self._width == 0:
            raise ValueError('empty rows not supported')

    def __getitem__(self, ij_pair: tuple[int, int]) -> int:
        """Gets the weight ("risk") of the cell (i, j)."""
        i, j = ij_pair  # pylint: disable=invalid-name

        if not self._cell_exists(i, j):
            raise ValueError(f'cell coordinates ({i}, {j}) out of range')

        return self._rows[i][j]

    @property
    def height(self) -> int:
        """The height of (number of rows in) the board."""
        return self._height

    @property
    def width(self) -> int:
        """The width of (number of columns in) the board."""
        return self._width

    def find_min_cost_path(self) -> PathCostPair[tuple[int, int], int]:
        """
        Finds the minimum-cost path from upper-left to lower right.

        The cost is the sum of the values of all vertices (cells) except the
        starting cell.
        """
        i = self._height - 1
        j = self._width - 1
        result = self._dijkstra((0, 0), (i, j))
        return PathCostPair(result.path_to((i, j)), result.cost_to((i, j)))

    def find_min_cost_down_right_path(self) \
            -> PathCostPair[tuple[int, int], int]:
        """
        Finds the minimum cost path from upper-left to lower right that only
        goes downward and rightward.

        The cost is the sum of the values of all vertices (cells) except the
        starting cell.
        """
        parents = dict[tuple[int, int], tuple[int, int]]()
        costs = dict[tuple[int, int], int]()

        costs[0, 0] = 0

        for j in range(1, self._width):  # pylint: disable=invalid-name
            costs[0, j] = costs[0, j - 1] + self[0, j]
            parents[0, j] = (0, j - 1)

        for i in range(1, self._height):  # pylint: disable=invalid-name
            costs[i, 0] = costs[i - 1, 0] + self[i, 0]
            parents[i, 0] = (i - 1, 0)

            for j in range(1, self._width):  # pylint: disable=invalid-name
                if costs[i - 1, j] < costs[i, j - 1]:
                    costs[i, j] = costs[i - 1, j] + self[i, j]
                    parents[i, j] = (i - 1, j)
                else:
                    costs[i, j] = costs[i, j - 1] + self[i, j]
                    parents[i, j] = (i, j - 1)

        tree = _PathTree((0, 0), parents, costs)
        finish = (self._height - 1, self._width - 1)
        return PathCostPair(tree.path_to(finish), tree.cost_to(finish))

    def _dijkstra(self,
                  start: tuple[int, int],
                  finish: tuple[int, int] | None = None) \
            -> _PathTree[tuple[int, int], int]:
        """
        Runs Dijkstra's algorithm to find shortest paths from the start vertex.

        If a finish vertex is supplied, stops when the shortest path to it has
        been found, even if shortest paths to some other reachable vertices
        have not yet been determined.
        """
        parents = dict[tuple[int, int], tuple[int, int]]()
        costs = dict[tuple[int, int], int]()
        done = set[tuple[int, int]]()  # FIXME: Actually use this properly!
        heap: list[tuple[int, tuple[int, int]]] = [(0, start)]

        while heap:
            src_cost, src = heapq.heappop(heap)
            if src in done:  # For multiple inserts (in lieu of decrease-key).
                continue

            costs[src] = src_cost
            if src == finish:
                break

            i, j = src  # pylint: disable=invalid-name

            for dest in (i, j - 1), (i, j + 1), (i - 1, j), (i + 1, j):
                if dest in done:
                    continue

                h, k = dest  # pylint: disable=invalid-name
                if not self._cell_exists(h, k):
                    continue

                new_dest_cost = src_cost + self[h, k]
                if costs.get(dest, math.inf) > new_dest_cost:
                    costs[dest] = new_dest_cost
                    parents[dest] = src
                    heapq.heappush(heap, (new_dest_cost, dest))

        return _PathTree(start, parents, costs)

    def _cell_exists(self, i: int, j: int) -> bool:
        """Checks if the cell coordinates are in range."""
        return 0 <= i < self._height and 0 <= j < self._width


_BRIGHT_GREEN = colorama.Style.BRIGHT + colorama.Fore.GREEN

_RESET_ALL = colorama.Style.RESET_ALL


@typechecked
def _parse_options() -> argparse.Namespace:
    """Parses command-line options."""
    parser = argparse.ArgumentParser()

    parser.add_argument('-v', '--verbose',
                        help='show the grid, with the path in green',
                        action='store_true')

    parser.add_argument('-a', '--acyclic',
                        help='use the DAG allowing only right and down moves',
                        action='store_true')

    options, remaining_args = parser.parse_known_intermixed_args()
    sys.argv[1:] = remaining_args
    return options


@typechecked
def run() -> None:
    """Reads input, finds the path, and shows it and its cost."""
    options = _parse_options()
    lines: Iterable[str] = fileinput.input()
    grid = Grid(map(str.strip, lines))

    if options.acyclic:
        result = grid.find_min_cost_down_right_path()
    else:
        result = grid.find_min_cost_path()

    if options.verbose:
        path_coords = set(result.path)

        colorama.init()
        print(_RESET_ALL, end='')

        for i in range(grid.height):
            for j in range(grid.width):
                if (i, j) in path_coords:
                    print(f'{_BRIGHT_GREEN}{grid[i, j]}{_RESET_ALL}', end='')
                else:
                    print(grid[i, j], end='')
            print()

        print()

    print(f'cost = {result.cost}')


__all__ = [thing.__name__  # type: ignore
           for thing in (PathCostPair, Grid, run)]


if __name__ == '__main__':
    run()
