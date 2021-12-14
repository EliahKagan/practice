#!/usr/bin/env python

"""Advent of Code 2021, day 8, part A"""

import fileinput
import itertools


UNSCRAMBLED_DIGITS = (
    'abcefg',   # 0
    'cf',       # 1
    'acdeg',    # 2
    'acdfg',    # 3
    'bcdf',     # 4
    'abdfg',    # 5
    'abdefg',   # 6
    'acf',      # 7
    'abcdefg',  # 8
    'abcdfg',   # 9
)


def normalize(digit):
    """Normalize (the representation of a) digit by sorting it internally."""
    return ''.join(sorted(digit))


def scramble(digit, permutation):
    """Scrambles a digit representation, using a permutation of range(7)."""
    return normalize(chr(ord('a') + permutation[ord(letter) - ord('a')])
                     for letter in digit)


def scramble_all_digits_by_permutation(permutation):
    """Scrambles each digit (0 through 9) using the permutation of range(7)."""
    return tuple(scramble(digit, permutation) for digit in UNSCRAMBLED_DIGITS)


ALL_SCRAMBLINGS = tuple(map(scramble_all_digits_by_permutation,
                            itertools.permutations(range(7))))


def crack(shuffled_digits, message):
    """Decrypts a message, based on shuffled (unordered) scrambled digits."""
    if len(shuffled_digits) != len(UNSCRAMBLED_DIGITS):
        raise ValueError('wrong number of digits in input')

    # Reshuffle the digits to an alphabetized shuffling digits (after
    # normalizing each one) so they can be compared as a set.
    sorted_shuffled_digits = sorted(map(normalize, shuffled_digits))

    # Use brute force to find all scramblings consistent with the input.
    possible_scramblings = [scrambling for scrambling in ALL_SCRAMBLINGS
                            if sorted(scrambling) == sorted_shuffled_digits]

    # If the result is not a unique possible scrambling, this can't be solved.
    if len(possible_scramblings) != 1:
        raise ValueError(f'{len(possible_scramblings)} possible scramblings')

    scrambling = possible_scramblings[0]

    try:
        return [scrambling.index(normalize(digit)) for digit in message]
    except ValueError as error:
        raise ValueError("scrambling can't decode message") from error


def run():
    """Reads input from stdin or a file an decode the messages."""
    for line in fileinput.input():
        shuffled_digits, message = (text.split() for text in line.split('|'))
        print(*crack(shuffled_digits, message), sep=', ')


if __name__ == '__main__':
    run()
