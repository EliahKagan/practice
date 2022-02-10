#!/usr/bin/env python

"""
Advent of Code 2021, day 6, part A

This same logic (with a different number of iterations) solves part B. See
day06b.py, which import this module.
"""

import fileinput
import re
from typing import Iterable

from typeguard import typechecked


SPLITTER = re.compile(r'[\s,]+')
"""We will split input separated by commas and/or whitespace."""

ORDER = 9
"""Timer values are in the range [0, ORDER)."""

RESET = 6
"""Timers that would go negative are reset to RESET."""

_PERIOD = 80
"""The number of days to run the part A simulation for."""


@typechecked
def evolve_counts(counts: list[int], period: int) -> None:
    """Evolves lanternfish timer-population counts by period ticks."""
    if len(counts) != ORDER:
        raise ValueError('wrong length list of counts')

    for _ in range(period):
        zeros = counts.pop(0)
        counts.append(zeros)
        counts[RESET] += zeros


@typechecked
def read_timers() -> Iterable[int]:
    """Reads integers from stdin or a file, separated by commas/whitespace."""
    all_input = '\n'.join(fileinput.input())
    return (int(token) for token in SPLITTER.split(all_input) if token)


@typechecked
def run(period: int) -> None:
    """Reads lanternfish timers. Outputs total population after period days."""
    counts = [0] * ORDER
    for timer in read_timers():
        counts[timer] += 1

    evolve_counts(counts, period)
    print(sum(counts))


if __name__ == '__main__':
    run(_PERIOD)
