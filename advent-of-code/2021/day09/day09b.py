#!/usr/bin/env python

"""
Advent of Code 2021, day 9, part B

According to the problem description, "Locations of height 9 do not count as
being in any basin, and all other locations will always be part of exactly one
basin." So it appears that the only inputs that need to be handled are those
for which finding regions separated by 9s is sufficient.
"""

import fileinput
import functools
import heapq
import itertools
import operator
from typing import Any, Iterable, Sequence

from typeguard import typechecked


WALL_VALUE = 9


@typechecked
class Grid:
    """A grid of the lava cave's topography."""

    __slots__ = ('_rows', '_height', '_width')

    _rows: Sequence[Sequence[int]]
    _height: int
    _width: int

    def __init__(self, rows: Iterable[Iterable[Any]]) -> None:
        """Creates a new grid by copying height values from the given rows."""
        self._rows = tuple(tuple(map(int, row)) for row in rows)

        self._height = len(self._rows)
        if self._height == 0:
            raise ValueError('empty grid not allowed (no rows)')

        self._width = len(self._rows[0])
        if any(len(row) != self._width for row in self._rows):
            raise ValueError('jagged grid not allowed')
        if self._width == 0:
            raise ValueError('empty rows not allowed')

    @property
    def height(self) -> int:
        """The number of rows in the grid."""
        return self._height

    @property
    def width(self) -> int:
        """The number of columns in the grid."""
        return self._width

    @property
    def component_areas(self) -> Iterable[int]:
        """Yields the areas of all components (walled off by WALL_VALUE)."""
        grid = [list(row) for row in self._rows]

        def dfs(i: int, j: int) -> int:
            if not (0 <= i < self._height and 0 <= j < self._width):
                return 0
            if grid[i][j] == WALL_VALUE:
                return 0
            grid[i][j] = WALL_VALUE
            return (1 + dfs(i, j - 1) + dfs(i, j + 1)
                      + dfs(i - 1, j) + dfs(i + 1, j))

        for i, j in itertools.product(range(self._height), range(self._width)):
            area = dfs(i, j)
            if area != 0:
                yield area


@typechecked
def run() -> None:
    """Reads a grid. Prints the product of its three largest basin areas."""
    lines: Iterable[str] = fileinput.input()
    grid = Grid(map(str.strip, lines))
    largest = heapq.nlargest(3, grid.component_areas)
    print(functools.reduce(operator.mul, largest))


if __name__ == '__main__':
    run()
