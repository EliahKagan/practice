#!/usr/bin/env python

"""Advent of Code 2021, day 13, part B"""

import fileinput
import re
from typing import NamedTuple

import colorama
from typeguard import typechecked


class Dot(NamedTuple):
    """A dot, represented as (x, y) coordinates."""
    x: int
    y: int


def _fold_one_x(x_fold: int, dot: Dot) -> Dot:
    """Folds a single dot over a horizontal axis of the given x-coordinate."""
    if dot.x < x_fold:
        return dot
    if dot.x > x_fold:
        return Dot(x_fold * 2 - dot.x, dot.y)
    raise ValueError(f'{dot!r} on horizontal crease at x={x_fold!r}')


def _fold_one_y(y_fold: int, dot: Dot) -> Dot:
    """Folds a single dot over a vertical axis of the given y-coordinate."""
    if dot.y < y_fold:
        return dot
    if dot.y > y_fold:
        return Dot(dot.x, y_fold * 2 - dot.y)
    raise ValueError(f'{dot!r} on vertical crease at y={y_fold!r}')


_DOT_SYMBOL = f'{colorama.Fore.RED}#{colorama.Style.RESET_ALL}'

_EMPTY_SYMBOL = '.'


@typechecked
class Dots:
    """Collection of dots on foldable paper."""

    __slots__ = ('_dots',)

    _dots: set[Dot]

    def __init__(self):
        """Creates an initially empty collection of dots."""
        self._dots = set()

    def __str__(self) -> str:
        """Produces a multi-line string tabular representation of the dots."""
        height = max(y for _, y in self._dots) + 1
        width = max(x for x, _ in self._dots) + 1

        def make_row(y):  # pylint: disable=invalid-name
            symbols = ((_DOT_SYMBOL if (x, y) in self._dots else _EMPTY_SYMBOL)
                       for x in range(width))
            return ''.join(symbols)

        joined = '\n'.join(make_row(y) for y in range(height))
        return colorama.Style.RESET_ALL + joined

    def __bool__(self) -> bool:
        """Tells if there are any dots in this collection."""
        return bool(self._dots)

    def __len__(self) -> int:
        """Gets the number of dots in this collection."""
        return len(self._dots)

    def add(self, x: int, y: int) -> None:  # pylint: disable=invalid-name
        """Adds a dot at the given coordinates."""
        self._dots.add(Dot(x, y))

    def fold_x(self, x: int) -> None:  # pylint: disable=invalid-name
        """Folds the paper along a line parallel to the x-axis."""
        self._dots = {_fold_one_x(x, dot) for dot in self._dots}

    def fold_y(self, y: int) -> None:  # pylint: disable=invalid-name
        """Folds the paper along a line parallel to the y-axis."""
        self._dots = {_fold_one_y(y, dot) for dot in self._dots}


DOT_PARSER = re.compile(r'^(\d+),(\d+)$')

FOLD_PARSER = re.compile(r'^fold along ([xy])=(\d+)$')

FOLDERS = dict(x=Dots.fold_x, y=Dots.fold_y)


@typechecked
def run() -> None:
    """
    Creates dots from stdin or a file, applies all folds, and shows the result.
    """
    dots = Dots()

    for line in map(str.strip, fileinput.input()):
        if not line:
            continue

        dot_match = DOT_PARSER.fullmatch(line)
        if dot_match is not None:
            dots.add(*map(int, dot_match.groups()))
            continue

        fold_match = FOLD_PARSER.fullmatch(line)
        if fold_match is not None:
            variable, position = fold_match.groups()
            FOLDERS[variable](dots, int(position))

    colorama.init()
    print(dots)


if __name__ == '__main__':
    run()
