#!/usr/bin/env python

"""Advent of Code 2021, day 15, part B"""

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
@attr.s(frozen=True, slots=True, auto_attribs=True)
class PathCostPair(Generic[TVertex, TCost]):
    """A path given as a sequence of vertices, and the cost to traverse it."""
    path: list[TVertex]
    cost: TCost


MAX_DIGIT = 9


# @typechecked  # Too slow.
class Grid:
    """A game board for the path-finding puzzle."""

    __slots__ = (
        '_rows',
        '_height_multiplier',
        '_width_multiplier',
        '_tile_height',
        '_tile_width',
    )

    _rows: Sequence[Sequence[int]]
    _height_multiplier: int
    _width_multiplier: int
    _tile_height: int
    _tile_width: int

    def __init__(self, rows: Iterable[Iterable[Any]]) -> None:
        """Creates a grid with the given rows."""
        self._height_multiplier = self._width_multiplier = 1

        self._rows = tuple(tuple(map(int, row)) for row in rows)
        self._tile_height = len(self._rows)

        if self._tile_height == 0:
            raise ValueError('empty board (no rows) not supported')

        self._tile_width = len(self._rows[0])

        if any(len(row) != self._tile_width for row in self._rows):
            raise ValueError('jagged board not supported')

        if self._tile_width == 0:
            raise ValueError('empty rows not supported')

    def __getitem__(self, ij_pair: tuple[int, int]) -> int:
        """Gets the weight ("risk") of the cell (i, j)."""
        i, j = ij_pair  # pylint: disable=invalid-name

        if not self._cell_exists(i, j):
            raise ValueError(f'cell coordinates ({i}, {j}) out of range')

        i_major, i_minor = divmod(i, self._tile_height)
        j_major, j_minor = divmod(j, self._tile_width)
        base_value = self._rows[i_minor][j_minor]
        return (base_value - 1 + i_major + j_major) % MAX_DIGIT + 1

    @property
    def height(self) -> int:
        """The height of (number of rows in) the board."""
        return self._tile_height * self._height_multiplier

    @property
    def width(self) -> int:
        """The width of (number of columns in) the board."""
        return self._tile_width * self._width_multiplier

    @property
    def tile_height(self) -> int:
        """The height of (number of rows in) a single tile."""
        return self._tile_height

    @property
    def tile_width(self) -> int:
        """The width of (number of columns in) a single tile."""
        return self._tile_width

    @property
    def height_multiplier(self) -> int:
        """The number of rows of tiles."""
        return self._height_multiplier

    @height_multiplier.setter
    def height_multiplier(self, new_height_multiplier: int) -> None:
        """Sets the number of rows of tiles."""
        if new_height_multiplier < 1:
            raise ValueError('height multiplier must be positive')
        self._height_multiplier = new_height_multiplier

    @property
    def width_multiplier(self) -> int:
        """The number of columns of tiles."""
        return self._width_multiplier

    @width_multiplier.setter
    def width_multiplier(self, new_width_multiplier: int) -> None:
        """Sets the number of columns of tiles."""
        if new_width_multiplier < 1:
            raise ValueError('width multiplier must be positive')
        self._width_multiplier = new_width_multiplier

    def find_min_cost_path(self) -> PathCostPair[tuple[int, int], int]:
        """
        Finds the minimum-cost path from upper-left to lower right.

        The cost is the sum of the values of all vertices (cells) except the
        starting cell.
        """
        i = self.height - 1  # pylint: disable=invalid-name
        j = self.width - 1  # pylint: disable=invalid-name
        parents, costs = self._dijkstra((0, 0), (i, j))
        path = [(i, j)]
        cost = costs[(i, j)]

        while (i, j) != (0, 0):
            i, j = parents[(i, j)]
            path.append((i, j))

        path.reverse()
        return PathCostPair(path, cost)

    def _dijkstra(self,
                  start: tuple[int, int],
                  finish: tuple[int, int] | None = None) \
            -> tuple[Mapping[tuple[int, int], tuple[int, int]],
                     Mapping[tuple[int, int], int]]:
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

        return parents, costs

    def _cell_exists(self, i: int, j: int) -> bool:
        return 0 <= i < self.height and 0 <= j < self.width


_BRIGHT_GREEN = colorama.Style.BRIGHT + colorama.Fore.GREEN

_RESET_ALL = colorama.Style.RESET_ALL


@typechecked
def _parse_options() -> argparse.Namespace:
    """Parses command-line options."""
    parser = argparse.ArgumentParser()

    parser.add_argument('-v', '--verbose',
                        help='show the grid, with the path in green',
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
    grid.height_multiplier = grid.width_multiplier = 5
    result = grid.find_min_cost_path()

    if options.verbose:
        path_coords = set(result.path)

        colorama.init()
        print(_RESET_ALL, end='')

        for i in range(grid.height):  # pylint: disable=invalid-name
            for j in range(grid.width):  # pylint: disable=invalid-name
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
