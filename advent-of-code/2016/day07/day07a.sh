#!/bin/sh
# Advent of Code 2016, day 7, part A

grep -P '([^][])(?!\1)([^][])\2\1' input |
    grep -cvP '\[[^]]*([^][])(?!\1)([^][])\2\1'
