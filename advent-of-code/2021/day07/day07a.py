#!/usr/bin/env python

"""Advent of Code 2021, day 7, part A"""

import fileinput
import re
import statistics

SPLITTER = re.compile(r'[\s,]+')

all_input = '\n'.join(fileinput.input())
points = [int(token) for token in SPLITTER.split(all_input) if token]
median = statistics.median_low(points)
print(sum(abs(point - median) for point in points))
