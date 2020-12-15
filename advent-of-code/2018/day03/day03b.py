#!/usr/bin/env python3
# Advent of Code 2018, day 3, part B

import collections
import fileinput
import itertools
import re

PARSER = re.compile(r'#(\d+)\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)')

Claim = collections.namedtuple('Claim', ('index', 'x', 'y', 'width', 'height'))

def read_claims():
    for line in map(str.strip, fileinput.input()):
        if not line:
            continue

        try:
            groups = PARSER.fullmatch(line).groups()
        except AttributeError as e:
            raise ValueError(f'Malformed claim "{claim}".') from e

        yield Claim._make(map(int, groups))

def to_points(claim):
    return itertools.product(range(claim.x, claim.x + claim.width),
                             range(claim.y, claim.y + claim.height))

claims = list(read_claims())
board = {}

for claim in claims:
    for point in to_points(claim):
        board[point] = point in board # Insert as false, or change to true.

for claim in claims:
    if not any(board[point] for point in to_points(claim)): # No overlaps.
        print(claim)
