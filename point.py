#!/usr/bin/env python3
"""point.py - a simple Point class"""

import math


class Point:
    """A 2-dimensional point."""

    __slots__ = ('_x', '_y')

    def __init__(self, x=0, y=0):
        """Makes a point with the given coordinates."""
        self._x = x
        self._y = y

    def __repr__(self):
        """An eval-able representation of the point."""
        return f'Point({self._x}, {self._y})'

    def __str__(self):
        """A representation of the point suitable for user interfaces."""
        return f'(x={self._x}, y={self._y})'

    @property
    def x(self):
        """The x-coordinate."""
        return self._x

    @property
    def y(self):
        """The y-coordinate."""
        return self._y

    def distance(self, other):
        """Computes the Euclidean distance from another point."""
        return math.sqrt((self.x - other.x)**2 + (self.y - other.y)**2)


def run():
    """"Tests out the Point class."""
    p = Point(1.4, 2.7)
    q = Point(1, 1)
    print(f'Got objects {[p, q]}.')
    print(f'{p} is a distance ~{p.distance(q):.3F} from {q}.')


if __name__ == '__main__':
    run()
