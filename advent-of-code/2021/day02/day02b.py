#!/usr/bin/env python

"""Advent of Code 2021, day 2, part B"""

import fileinput


x = y = aim = 0

for action, arg_str in map(str.split, fileinput.input()):
    arg = int(arg_str)

    match action:
        case 'down':
            aim += arg
        case 'up':
            aim -= arg
        case 'forward':
            x += arg
            y += aim * arg

print(x * y)
