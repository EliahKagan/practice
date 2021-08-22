#!/usr/bin/env python3
"""rectangle.py - Axis-aligned rectangles."""


class Point:
    """A 2D point class."""

    __slots__ = ('_x', '_y')

    def __init__(self, x, y):
        """Creates a point with the specified coordinates."""
        self._x = x
        self._y = y

    def __repr__(self):
        """String representation. Can be passed to eval()."""
        return f'Point(x={self._x}, y={self._y})'

    def __str__(self):
        """String representation. Suitable for user interfaces."""
        return f'(x={self._x}, y={self._y})'

    def __eq__(self, other):
        """Checks if two points are equal."""
        return (isinstance(other, Point)
                and self._x == other._x
                and self._y == other._y)

    def __hash__(self):
        return hash((self._x, self._y))

    @property
    def x(self):
        """The x-coordinate."""
        return self._x

    @property
    def y(self):
        """The y-coordinate."""
        return self._y


class Rectangle:
    """An axis-aligned rectangle."""

    __slots__ = ('_x', '_y', '_width', '_height')

    def __init__(self, vertex, width, height):
        """Creates a rectangle from a lower-left corner, width, and height."""
        self._x = vertex.x
        self._y = vertex.y
        self._width = width
        self._height = height

    def __repr__(self):
        """String representation. Can be passed to eval()."""
        vertex = repr(Point(self._x, self._y))
        extent = f'width={self._width}, height={self._height}'
        return f'Rectangle({vertex}, {extent})'

    def __str__(self):
        """String representation. Suitable for user interfaces."""
        vertex = f'x={self._x}, y={self._y}'
        extent = f'width={self._width}, height={self._height}'
        return f'({vertex}, {extent})'

    @property
    def x(self):
        """The x-coordinate."""
        return self._x

    @property
    def y(self):
        """The y-coordinate."""
        return self._y

    @property
    def width(self):
        """The width of the rectangle."""
        return self._width

    @property
    def height(self):
        """The height of the rectangle."""
        return self._height

    def getWidth(self):
        """Same as reading the width property."""
        return self.width

    def getHeight(self):
        """Same as reading the height property."""
        return self.height

    def area(self):
        """Computes the area of the rectangle."""
        return self._width * self._height

    def perimeter(self):
        """Computes the perimeter of the rectangle."""
        return (self._width + self._height) * 2

    def transpose(self):
        """Mutates the rectangle to swap its width and height."""
        self._width, self._height = self._height, self._width

    def contains(self, point):
        """
        Checks if the point is in this rectangle.

        Edges not adjacent to the vertex given to construct the rectangle
        are considered not to be in the rectangle.
        """
        return (self._x <= point.x < self._x + self._width
                and self._y <= point.y < self._y + self._height)


def run():
    """Tries out the Rectangle class."""
    r = Rectangle(Point(4, 5), 6, 5)
    print(r)
    print(f'{r.x}, {r.y}, {r.getWidth()}, {r.getHeight()}')
    print(f'area={r.area()}')
    print(f'perimeter={r.perimeter()}')
    r.transpose()
    print(r)
    print()

    s = Rectangle(Point(0, 0), 10, 5)
    print(s.contains(Point(0, 0)), True)
    print(s.contains(Point(3, 3)), True)
    print(s.contains(Point(3, 7)), False)
    print(s.contains(Point(3, 5)), False)
    print(s.contains(Point(3, 4.99999)), True)
    print(s.contains(Point(-3, -3)), False)


if __name__ == '__main__':
    run()
