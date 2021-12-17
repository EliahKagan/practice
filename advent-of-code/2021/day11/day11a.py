#!/usr/bin/env python

"""
Advent of Code 2021, day 11, part A

Most of the implementation of part B is also here, in that it uses the Grid
class.
"""

import fileinput
from itertools import product
from typing import Any, Iterable

from typeguard import typechecked


__all__ = ['MIN_ENERGY', 'MAX_ENERGY', 'Grid', 'read_grid', 'run']


MIN_ENERGY = 0

MAX_ENERGY = 9

_STEP_COUNT = 100


@typechecked
class Grid:
    """A grid of glowing octopuses."""

    __slots__ = ('_rows', '_height', '_width')

    _rows: list[list[int | None]]

    def __init__(self, rows: Iterable[Iterable[Any]]):
        """Creates a new grid by copying energy levels from the given rows."""
        my_rows = [list(map(int, row)) for row in rows]

        self._height = len(my_rows)
        if self._height == 0:
            raise ValueError('empty grid not allowed (no rows)')

        self._width = len(my_rows[0])
        if any(len(row) != self._width for row in my_rows):
            raise ValueError('jagged grid not allowed')
        if self._width == 0:
            raise ValueError('empty rows not allowed')

        if not all(MIN_ENERGY <= energy <= MAX_ENERGY
                   for row in my_rows for energy in row):
            raise ValueError('not all input energies are in range')

        self._rows = my_rows  # type: ignore

    def __call__(self) -> int:
        """Simulates one step. Returns the number of flashes."""
        self._set_flashers_to_none()

        count = 0
        for i, j in self._all_coordinates:
            if self._rows[i][j] is None:
                self._rows[i][j] = MIN_ENERGY
                count += 1

        return count

    @property
    def height(self) -> int:
        """The number of rows in the grid."""
        return self._height

    @property
    def width(self) -> int:
        """The number of columns in the grid."""
        return self._width

    def _set_flashers_to_none(self) -> None:
        """
        Simulates one step, except sets flashers to None instead of 0.

        This is a helper function for __call__, which does the full simulation.
        """
        stack = []

        def visit(i: int, j: int) -> None:
            if not self._exists(i, j):
                return
            energy = self._rows[i][j]
            if energy is None:
                return
            if energy == MAX_ENERGY:
                self._rows[i][j] = None
                stack.append((i, j))
            else:
                self._rows[i][j] = energy + 1

        for i, j in self._all_coordinates:
            visit(i, j)

        while stack:
            # pylint: disable=invalid-name
            i, j = stack.pop()
            for h, k in product(range(i - 1, i + 2), range(j - 1, j + 2)):
                visit(h, k)

    @property
    def _all_coordinates(self) -> Iterable[tuple[int, int]]:
        """Yields all (i, j) coordinates of cells in the grid."""
        return product(range(self._height), range(self._width))

    def _exists(self, i: int, j: int) -> bool:
        """Tells if the given coordinates are in range (so the cell exists)."""
        return 0 <= i < self._height and 0 <= j < self._width


def read_grid() -> Grid:
    """Reads a grid of octopuses from stdin or a file."""
    return Grid(map(str.strip, fileinput.input()))


@typechecked
def run() -> None:
    """Reads a grid of octopuses and reports the 100-iterations flash total."""
    grid = read_grid()
    print(sum(grid() for _ in range(_STEP_COUNT)))


if __name__ == '__main__':
    run()
