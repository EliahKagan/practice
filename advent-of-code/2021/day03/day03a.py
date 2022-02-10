#!/usr/bin/env python3

"""Advent of Code 2021, day 3, part A"""

import fileinput
from typing import Sequence

from typeguard import typechecked


@typechecked
def majority(col: Sequence[int]) -> int:
    """Gets the majority bit of a column."""
    double_pop = sum(col) * 2
    if double_pop == len(col):
        raise ValueError('equally many ones and zeros')
    return int(double_pop > len(col))


@typechecked
def binary(bits: Sequence[int]) -> int:
    """Converts a sequence of ones and zeros to a binary number."""
    return int(''.join(map(str, bits)), base=2)


@typechecked
def run() -> None:
    """Solves the problem as described in input on stdin or a file."""
    rows = (map(int, line.strip()) for line in fileinput.input())
    cols = list(zip(*rows))
    gamma = [majority(col) for col in cols]
    epsilon = [int(not bit) for bit in gamma]
    print(binary(gamma) * binary(epsilon))


if __name__ == '__main__':
    run()
