#!/usr/bin/env python3
# Advent of Code 2018, day 3, part A

import fileinput
import itertools
import re

PARSER = re.compile(r'#\d+\s+@\s+(\d+),(\d+):\s+(\d+)x(\d+)')

def parse(claim):
    try:
        groups = PARSER.fullmatch(claim).groups()
    except AttributeError as e:
        raise ValueError(f'Malformed claim "{claim}".') from e

    return [int(token) for token in groups]

def read_claims():
    return (claim for claim in map(str.strip, fileinput.input()) if claim)

board = {}

for x, y, width, height in map(parse, read_claims()):
    for point in itertools.product(range(x, x + width), range(y, y + height)):
        board[point] = point in board # Insert as false, or change to true.

print(sum(board.values()))
