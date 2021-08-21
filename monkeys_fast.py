#!/usr/bin/env python3
"""monkeys.py - "monkeys" exercise from pythonds - much faster way"""

import itertools
import random
import string
import sys

REPORT_INTERVAL = 1000
CHARS = string.ascii_lowercase + ' '
GOAL = 'methinks it is like a weasel'


def check_length(guess):
    """Ensures the guess has the same length as the goal."""
    if len(guess) != len(GOAL):
        raise ValueError('wrong length guess')


def generate(guess):
    """Randomly changes the guess at one character position."""
    check_length(guess)
    index = random.randrange(len(GOAL))
    return guess[:index] + random.choice(CHARS) + guess[(index + 1):]


def score(guess):
    """Counts how many positions the guess is correct at."""
    check_length(guess)
    return sum(lhs == rhs for lhs, rhs in zip(guess, GOAL))


def run():
    """Repeatedly guess and check, occasionally reporting."""
    best = '-' * len(GOAL)
    best_score = 0

    for count in itertools.count(1):
        cur = generate(best)
        cur_score = score(cur)

        if cur_score == len(GOAL):
            print(f'Nice! Success.  "{cur}"')
            sys.exit(0)

        if best_score < cur_score:
            best_score = cur_score
            best = cur

        if count % REPORT_INTERVAL == 0:
            print(f'Best so far:  "{best}"')


if __name__ == '__main__':
    run()
