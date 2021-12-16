#!/usr/bin/env python

"""Advent of Code, day 15, part B"""

import collections
import fileinput
import heapq
import math

import colorama


PathCostPair = collections.namedtuple('PathCostPair', ('path', 'cost'))

PathCostPair.__doc__ = """
A path given as a sequence of vertices, and the cost to traverse it.
"""


MAX_DIGIT = 9


class Grid:
    """A game board for the path-finding puzzle."""

    __slots__ = (
        '_rows',
        '_height_multiplier',
        '_width_multiplier',
        '_tile_height',
        '_tile_width',
    )

    def __init__(self, rows):
        """Creates a grid with the given rows."""
        self._height_multiplier = self._width_multiplier = 1

        self._rows = tuple(tuple(map(int, row)) for row in rows)
        self._tile_height = len(self._rows)

        if self._tile_height == 0:
            raise ValueError('empty board (no rows) not supported')

        self._tile_width = len(self._rows[0])

        if any(len(row) != self._tile_width for row in self._rows):
            raise ValueError('jagged board not supported')

        if self._tile_width == 0:
            raise ValueError('empty rows not supported')

    def __getitem__(self, ij_pair):
        """Gets the weight ("risk") of the cell (i, j)."""
        i, j = ij_pair

        if not self._cell_exists(i, j):
            raise ValueError(f'cell coordinates ({i}, {j}) out of range')

        i_major, i_minor = divmod(i, self._tile_height)
        j_major, j_minor = divmod(j, self._tile_width)
        base_value = self._rows[i_minor][j_minor]
        return (base_value - 1 + i_major + j_major) % (MAX_DIGIT - 1) + 1

    @property
    def height(self):
        """The height of (number of rows in) the board."""
        return self._tile_height * self._height_multiplier

    @property
    def width(self):
        """The width of (number of columns in) the board."""
        return self._tile_width * self._width_multiplier

    @property
    def tile_height(self):
        """The height of (number of rows in) a single tile."""
        return self._tile_height

    @property
    def tile_width(self):
        """The width of (number of columns in) a single tile."""
        return self._tile_width

    @property
    def height_multiplier(self):
        """The number of rows of tiles."""
        return self._height_multiplier

    @height_multiplier.setter
    def height_multiplier(self, height):
        """Sets the number of rows of tiles."""
        if height < 1:
            raise ValueError('height multiplier must be positive')
        self._height_multiplier = height

    @property
    def width_multiplier(self):
        """The number of columns of tiles."""
        return self._width_multiplier

    @width_multiplier.setter
    def width_multiplier(self, width):
        """Sets the number of columns of tiles."""
        if width < 1:
            raise ValueError('width multiplier must be positive')
        self._width_multiplier = width

    def find_min_cost_path(self):
        """
        Finds the minimum-cost path from upper-left to lower right.

        The cost is the sum of the values of all vertices (cells) except the
        starting cell.
        """
        i = self.height - 1
        j = self.width - 1
        parents, costs = self._dijkstra((0, 0), (i, j))
        path = [(i, j)]
        cost = costs[(i, j)]

        while (i, j) != (0, 0):
            i, j = parents[(i, j)]
            path.append((i, j))

        path.reverse()
        return PathCostPair(path, cost)

    def _dijkstra(self, start, finish=None):
        parents = {}
        costs = collections.defaultdict(lambda: math.inf)
        done = set()
        heap = [(0, start)]

        while heap:
            src_cost, src = heapq.heappop(heap)
            if src in done:  # For multiple inserts (in lieu of decrease-key).
                continue

            costs[src] = src_cost
            if src == finish:
                break

            i, j = src

            for dest in (i, j - 1), (i, j + 1), (i - 1, j), (i + 1, j):
                if dest in done:
                    continue

                h, k = dest
                if not self._cell_exists(h, k):
                    continue

                new_dest_cost = src_cost + self[h, k]
                if costs[dest] > new_dest_cost:
                    costs[dest] = new_dest_cost
                    parents[dest] = src
                    heapq.heappush(heap, (new_dest_cost, dest))

        return parents, costs

    def _cell_exists(self, i, j):
        return 0 <= i < self.height and 0 <= j < self.width


BRIGHT_GREEN = colorama.Style.BRIGHT + colorama.Fore.GREEN

RESET_ALL = colorama.Style.RESET_ALL


def run():
    """Reads input, finds the path, and shows it and its cost."""
    colorama.init()
    print(RESET_ALL, end='')

    grid = Grid(map(str.strip, fileinput.input()))
    grid.height_multiplier = grid.width_multiplier = 5
    result = grid.find_min_cost_path()
    path_coords = set(result.path)

    for i in range(grid.height):
        for j in range(grid.width):
            if (i, j) in path_coords:
                print(f'{BRIGHT_GREEN}{grid[i, j]}{RESET_ALL}', end='')
            else:
                print(grid[i, j], end='')
        print()

    print(f'\ncost = {result.cost}')


__all__ = [thing.__name__ for thing in (PathCostPair, Grid, run)]


if __name__ == '__main__':
    run()
