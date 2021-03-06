#!/usr/bin/env python

"""Advent of Code 2021, day 10, part B"""

import fileinput
from typing import Iterable, Reversible

from bidict import bidict
from typeguard import typechecked


BRACKETS = bidict({'(': ')', '[': ']', '{': '}', '<': '>'})

WEIGHTS = {'(': 1, '[': 2, '{': 3, '<': 4}


@typechecked
def get_unmatched_openers(text: str) -> list[str] | None:
    """
    Gets a list of openers that were not matched by closers.

    Returns the list, or None if there were any unmatched closers.
    Raises ValueError if any character appears in the text other than known
    opening/closing characters.
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
            return None

    return stack


@typechecked
def compute_score(unmatched_openers: Reversible[str]) -> int:
    """Computes the "completion" score for the given unmatched prefix."""
    score = 0
    for ch in reversed(unmatched_openers):  # pylint: disable=invalid-name
        score = score * 5 + WEIGHTS[ch]
    return score


@typechecked
def run() -> None:
    """Reads the input and outputs the total completion score."""
    scores = []
    raw_lines: Iterable[str] = fileinput.input()

    for line in map(str.strip, raw_lines):
        unmatched_openers = get_unmatched_openers(line)
        if unmatched_openers is not None:
            scores.append(compute_score(unmatched_openers))

    if len(scores) % 2 == 0:
        raise ValueError(f"even number of scores ({len(scores)})")

    scores.sort()
    print(f'middle score = {scores[len(scores) // 2]}')


if __name__ == '__main__':
    run()
