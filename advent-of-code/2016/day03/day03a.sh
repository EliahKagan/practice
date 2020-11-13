#!/bin/sh
# Advent of Code 2016, day 3, part A

awk '$1+$2>$3 && $2+$3>$1 && $3+$1>$2' "$@" | wc -l

