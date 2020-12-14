#!/usr/bin/env python3
# Advent of Code 2018, day 2, part B

import fileinput

def distance(v, w):
    if len(v) != len(w):
        raise ValueError(f'"{v}" and "{w}" have different length.')

    return sum(1 for (x, y) in zip(v, w) if x != y)

def is_similar(v, w):
    return distance(v, w) == 1

words = [word for word in map(str.strip, fileinput.input()) if word]
if not words:
    raise ValueError("No words.")

for i, v in enumerate(words):
    for w in words[(i + 1):]:
        if is_similar(v, w):
            print(f'"{v}" is similar to "{w}".')
            print(''.join(x for (x, y) in zip(v, w) if x == y))
