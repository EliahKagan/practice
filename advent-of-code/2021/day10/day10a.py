#!/usr/bin/env python

"""Advent of Code 2021, day 10, part A"""

import fileinput
from typing import Iterable

from bidict import bidict
from typeguard import typechecked


BRACKETS = bidict({'(': ')', '[': ']', '{': '}', '<': '>'})

WEIGHTS = {None: 0, ')': 3, ']': 57, '}': 1197, '>': 25137}


@typechecked
def find_unmatched_closer(text: str) -> str | None:
    """
    Finds the first unmatched closing punctuator in a string of punctuation.

    Returns the character if one was found, or None if there were no
    mismatches. Raises ValueError if any character appears in the text other
    than known opening/closing characters.
    """
    # pylint: disable=unsupported-membership-test
    # pylint: disable=unsubscriptable-object

    stack = []

    for ch in text:  # pylint: disable=invalid-name
        if ch in BRACKETS:
            stack.append(ch)
        elif ch not in BRACKETS.inverse:
            raise ValueError(f'unknown punctuator {ch!r}')
        elif stack and stack[-1] == BRACKETS.inverse[ch]:
            del stack[-1]
        else:
            return ch

    return None


@typechecked
def run() -> None:
    """Reads the input and outputs the total syntax-error score."""
    raw_lines: Iterable[str] = fileinput.input()
    lines = map(str.strip, raw_lines)
    print(sum(WEIGHTS[find_unmatched_closer(line)] for line in lines))


if __name__ == '__main__':
    run()
