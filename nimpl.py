#!/usr/bin/env python3
"""
The common claim that magic dunder methods are mere "syntactic sugar" is not
accurate.
"""


class Box:
    """A thing that can't do much but can be added."""

    __slot__ = ('_value',)

    def __init__(self, value):
        """Makes a Widget with the specified value."""
        self._value = value

    def __repr__(self):
        """An eval-able representation of this Widget."""
        return f'Widget({self._value})'

    def __add__(self, other):
        """Takes the sum of this Widget with a Widget or bare value."""
        if isinstance(other, Box):
            return Box(self._value + other._value)

        return Box(self._value + other)


def run():
    """Show the relationship between binary + and the __add__ method."""
    x = Box(5)
    y = Box(10)
    print(x + y)
    print(x + 2)
    print(2 + x)


if __name__ == '__main__':
    run()
