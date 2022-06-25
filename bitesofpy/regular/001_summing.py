"""Bite 1. Sum n numbers"""


def sum_numbers(numbers=None):
    return sum(range(1, 101) if numbers is None else numbers)
