"""Advent of Code 2015, day 1, part A"""


def what_floor(parens):
    """Find what floor of the building a sequence of parentheses represents."""
    return parens.count('(') - parens.count(')')
