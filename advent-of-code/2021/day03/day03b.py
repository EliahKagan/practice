#!/usr/bin/env python

"""Advent of Code, day 3, part B"""

import fileinput
from typing import Callable

from typeguard import typechecked


@typechecked
def majority(rows: list[list[int]], col_index: int) -> int:
    """
    Gets the majority bit of a column.

    Assumes all entries are 1 or 0. In a tie, 1 wins.
    """
    col = [row[col_index] for row in rows]
    return int(sum(col) * 2 >= len(col))


@typechecked
def minority(rows: list[list[int]], col_index: int) -> int:
    """
    Gets the minority bit of a column.

    Assumes all entries are 1 or 0. In a tie, 0 wins.
    """
    return int(not majority(rows, col_index))


@typechecked
def positional_filter(rows: list[list[int]],
                      selector: Callable[[list[int], int], int]) -> list[int]:
    """Finds a row by eliminating non-matching rows per bit position."""
    if not rows:
        raise ValueError('no rows to filter')

    width = len(rows[0])
    if any(len(row) != width for row in rows):
        raise ValueError('not all rows have the same width')

    if len(rows) == 1:
        return rows[0]

    for col_index in range(width):
        keep_bit = selector(rows, col_index)
        rows = [row for row in rows if row[col_index] == keep_bit]
        if len(rows) == 1:
            return rows[0]

    raise ValueError(f'applied all filters, {len(rows)} rows left')


@typechecked
def rate(rows: list[list[int]],
         selector: Callable[[list[int], int], int]) -> int:
    """Eliminates non-matching rows. Converts the surviving row to an int."""
    return int(''.join(map(str, positional_filter(rows, selector))), base=2)


@typechecked
def run() -> None:
    """Solves the problem as described in input on stdin or a file."""
    rows = [list(map(int, line.strip())) for line in fileinput.input()]
    by_majority = rate(rows, majority)
    print('Ratings')
    print(f'  oxygen generator: {by_majority}')
    by_minority = rate(rows, minority)
    print(f'      CO2 scrubber: {by_minority}')
    print()
    print(f'Puzzle answer (their product):  {by_majority * by_minority}')


if __name__ == '__main__':
    run()
