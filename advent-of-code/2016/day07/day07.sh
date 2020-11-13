#!/bin/sh
# Advent of Code 2016, day 7, part A

<input grep -P '([^][])(?!\1)([^][])\2\1' |
    grep -vP '\[[^]]*([^][])(?!\1)([^][])\2\1' |
    wc -l
