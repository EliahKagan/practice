#!/usr/bin/env python3
"""monkeys.py - "monkeys" exercise from pythonds"""

import itertools
import random
import string
import sys

REPORT_INTERVAL = 1_000_000
CHARS = string.ascii_lowercase + ' '
GOAL = 'methinks it is like a weasel'


def generate():
    """Generates the guess."""
    return ''.join(random.choice(CHARS) for _ in GOAL)


def score(guess):
    """Counts how many positions the guess is correct at."""
    if len(guess) != len(GOAL):
        raise ValueError('wrong length guess')

    return sum(lhs == rhs for lhs, rhs in zip(guess, GOAL))


def run():
    """Repeatedly guess and check, occasionally reporting."""
    best = '\0' * len(GOAL)
    best_score = 0

    for count in itertools.count(1):
        cur = generate()
        cur_score = score(cur)

        if cur_score == len(GOAL):
            print(f'Whoa! Success!  "{cur}"')
            sys.exit(0)

        if best_score < cur_score:
            best_score = cur_score
            best = cur

        if count % REPORT_INTERVAL == 0:
            print(f'Best so far:  "{best}"')


if __name__ == '__main__':
    run()
