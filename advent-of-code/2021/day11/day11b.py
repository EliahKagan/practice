#!/usr/bin/env python

"""
Advent of Code 2021, day 11, part B

This short file uses the day11a.Grid class. See day11a.py.
"""

import itertools
from typeguard import typechecked
import day11a


def find_first_all_flashing_time(grid: day11a.Grid):
    """Reports the lowest step number (1-based) when all octopuses flash."""
    area = grid.height * grid.width

    for time in itertools.count(1):
        if grid() == area:
            return time

    raise AssertionError('unreachable')


@typechecked
def run() -> None:
    """Reads octopus grid and reports number of first all-flashing step."""
    print(find_first_all_flashing_time(day11a.read_grid()))


if __name__ == '__main__':
    run()
