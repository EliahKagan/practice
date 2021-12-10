#!/usr/bin/env python3

"""Advent of Code, day 1, part A"""

import fileinput
import itertools


pairs = itertools.pairwise(map(int, fileinput.input()))
print(sum(pre < cur for pre, cur in pairs))
