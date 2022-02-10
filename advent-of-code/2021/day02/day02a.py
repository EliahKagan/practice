#!/usr/bin/env python

"""Advent of Code 2021, day 2, part A"""

import fileinput


x = y = 0

for action, delta_str in map(str.split, fileinput.input()):
    delta = int(delta_str)

    match action:
        case 'forward':
            x += delta
        case 'down':
            y += delta
        case 'up':
            y -= delta

print(x * y)
