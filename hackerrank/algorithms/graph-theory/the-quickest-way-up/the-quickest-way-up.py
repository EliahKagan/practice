#!/usr/bin/env python3

"""
https://www.hackerrank.com/challenges/the-quickest-way-up
In Python 3. Using breadth-first search through an implicit graph.
"""

import collections

# The number of squares in the Snakes & Ladders board.
BOARD_SIZE = 100


def read_value():
    """Reads a line as a single integer."""
    return int(input())


def read_record():
    """Reads a line as a sequence of integers."""
    return map(int, input().split())


def read_edges():
    """Reads a sequence of snakes or ladders, which are directed edges."""
