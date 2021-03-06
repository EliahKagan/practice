#!/usr/bin/env python

"""
Advent of Code 2021, day 14

When run as a script, this solves part A. But part B is solved with the same
logic, just more repetitions. See day14b.py.
"""

from collections import Counter
import fileinput
import itertools
import re
from typing import Iterable, Iterator, Mapping, NamedTuple

from typeguard import typechecked


RULE_PARSER = re.compile(r'^\s*(\w)(\w)\s+->\s+(\w)\s*$')


@typechecked
class PolymerSummary(NamedTuple):
    """Element and pair counts of a "polymer"."""
    elem_counts: Mapping[str, int]
    pair_counts: Mapping[tuple[str, str], int]


@typechecked
def polymerize(template_text: str,
               rules: dict[tuple[str, str], str],
               reps: int) -> PolymerSummary:
    """Transforms element and pair counts according to pair insertion rules."""
    elem_counts = Counter(template_text)
    pair_counts = Counter(itertools.pairwise(template_text))

    for _ in range(reps):
        next_pair_counts = Counter[tuple[str, str]]()

        for pair, count in pair_counts.items():
            try:
                between = rules[pair]
            except KeyError:
                next_pair_counts[pair] += count
            else:
                elem_counts[between] += count
                left, right = pair
                next_pair_counts[(left, between)] += count
                next_pair_counts[(between, right)] += count

        pair_counts = next_pair_counts

    return PolymerSummary(elem_counts, pair_counts)


@typechecked
def read_rules(lines: Iterable[str]) -> dict[tuple[str, str], str]:
    """Reads transformation rules from lines of text."""
    rules = {}

    for line in map(str.strip, lines):
        if not line:
            continue

        rule = RULE_PARSER.fullmatch(line)
        if not rule:
            raise ValueError(f'malformed rule: {line}')

        left, right, between = rule.groups()
        if (left, right) in rules:
            raise ValueError(f'duplicate rules for "{left}{right}"')

        rules[(left, right)] = between

    return rules


@typechecked
def run(reps: int) -> None:
    """Reads input from stdin or a file and outputs a solution."""
    line_iterator: Iterator[str] = fileinput.input()

    template_text = next(line_iterator).strip()
    if not template_text:
        raise ValueError('first input line needs nonempty template text')

    rules = read_rules(line_iterator)
    print('Running 1 rep.' if reps == 1 else f'Running {reps} reps.')
    counts = polymerize(template_text, rules, reps).elem_counts.values()
    assert counts, 'nonempty template text should result in nonempty output'

    print(f'length = {sum(counts)}')

    min_count = min(counts)
    max_count = max(counts)

    print(f'min count = {min_count}')
    print(f'max count = {max_count}')
    print(f'difference = {max_count - min_count}')


if __name__ == '__main__':
    run(10)
