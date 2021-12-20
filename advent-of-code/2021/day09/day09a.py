#!/usr/bin/env python

"""Advent of Code 2021, day 9, part A"""

import fileinput
import itertools
from typing import Any, Iterable

from typeguard import typechecked


@typechecked
class Grid:
    """A grid of the lava cave's topography."""

    __slots__ = ('_rows', '_height', '_width')

    _rows: list[list[int]]
    _height: int
    _width: int

    def __init__(self, rows: Iterable[Iterable[Any]]) -> None:
        """Creates a new grid by copying height values from the given rows."""
        self._rows = [list(map(int, row)) for row in rows]

        self._height = len(self._rows)
        if self._height == 0:
            raise ValueError('empty grid not allowed (no rows)')

        self._width = len(self._rows[0])
        if any(len(row) != self._width for row in self._rows):
            raise ValueError('jagged grid not allowed')
        if self._width == 0:
            raise ValueError('empty rows not allowed')

    @property
    def low_point_values(self) -> Iterable[int]:
        """
        Yields the heights surrounded all by strictly lower heights.

        This gives the actual values, not their coordinates.
        """
        for i, j in itertools.product(range(self._height), range(self._width)):
            height = self._rows[i][j]
            if all(self._rows[h][k] > height
                   for h, k in self._neighbors(i, j)):
                yield height

    @property
    def height(self) -> int:
        """The number of rows in the grid."""
        return self._height

    @property
    def width(self) -> int:
        """The number of columns in the grid."""
        return self._width

    def _neighbors(self, i: int, j: int) -> Iterable[tuple[int, int]]:
        """The cells adjacent to the cell with the given coordinates."""
        return ((h, k)
                for h, k in ((i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1))
                if 0 <= h < self._height and 0 <= k < self._width)


@typechecked
def run() -> None:
    """Reads a grid from stdin or a file. Prints the sum of its risk levels."""
    lines: Iterable[str] = fileinput.input()
    grid = Grid(map(str.strip, lines))
    print(sum(1 + height for height in grid.low_point_values))


if __name__ == '__main__':
    run()
