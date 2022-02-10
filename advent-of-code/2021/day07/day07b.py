#!/usr/bin/env python

"""Advent of Code 2021, day 7, part B"""

import fileinput
import re

from typeguard import typechecked


SPLITTER = re.compile(r'[\s,]+')


def distance(point1: int, point2: int) -> int:
    """Stair-sum distance function (crab submarine movement cost)."""
    diff = abs(point1 - point2)
    return diff * (diff + 1) // 2


@typechecked
def find_min_distance(points: list[int]) -> int:
    """Finds the minimum stair-sum distance to the given points."""
    return min(sum(distance(candidate, point) for point in points)
               for candidate in range(min(points), max(points) + 1))


@typechecked
def read_points() -> list[int]:
    """Reads 1-dimensional point coordinates from stdin or a file."""
    all_input = '\n'.join(fileinput.input())
    return [int(token) for token in SPLITTER.split(all_input) if token]


if __name__ == '__main__':
    print(find_min_distance(read_points()))
