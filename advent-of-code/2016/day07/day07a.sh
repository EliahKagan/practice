#!/bin/sh
# Advent of Code 2016, day 7, part A

grep -P '(\w)(?!\1)(\w)\2\1' "$@" | grep -cvP '\[\w*(\w)(?!\1)(\w)\2\1'
