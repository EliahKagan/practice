#!/usr/bin/env python3
# Advent of Code 2018, day 2, part A

import collections
import fileinput

twos = threes = 0

for word in map(str.strip, fileinput.input()):
    freqs = collections.Counter(word).values()
    if 2 in freqs:
        twos += 1
    if 3 in freqs:
        threes += 1

print(twos * threes)
