#!/usr/bin/env python3

"""Advent of Code, day 1, part B"""

import fileinput
import itertools

import more_itertools


triples = more_itertools.windowed(map(int, fileinput.input()), 3)
pairs = itertools.pairwise(map(sum, triples))
print(sum(pre < cur for pre, cur in pairs))
