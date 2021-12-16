#!/usr/bin/env python

"""Advent of Code, day 15, part A"""

import collections
import fileinput
import heapq
import math

import colorama


PathCostPair = collections.namedtuple('PathCostPair', ('path', 'cost'))

PathCostPair.__doc__ = """
A path given as a sequence of vertices, and the cost to traverse it.
"""


class Grid:
    """A game board for the path-finding puzzle."""

    __slots__ = ('_rows', '_width', '_height')

    def __init__(self, rows):
        """Creates a grid with the given rows."""
        self._rows = tuple(tuple(map(int, row)) for row in rows)
        self._height = len(self._rows)

        if self._height == 0:
            raise ValueError('empty board (no rows) not supported')

        self._width = len(self._rows[0])

        if any(len(row) != self._width for row in self._rows):
            raise ValueError('jagged board not supported')

        if self._width == 0:
            raise ValueError('empty rows not supported')

    def __getitem__(self, ij_pair):
        """Gets the weight ("risk") of the cell (i, j)."""
        i, j = ij_pair

        if not self._cell_exists(i, j):
            raise ValueError(f'cell coordinates ({i}, {j}) out of range')

        return self._rows[i][j]

    @property
    def height(self):
        """The height of (number of rows in) the board."""
        return self._height

    @property
    def width(self):
        """The width of (number of columns in) the board."""
        return self._width

    def find_min_cost_path(self):
        """
        Finds the minimum-cost path from upper-left to lower right.

        The cost is the sum of the values of all vertices (cells) except the
        starting cell.
        """
        i = self._height - 1
        j = self._width - 1
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
        return 0 <= i < self._height and 0 <= j < self._width


BRIGHT_GREEN = colorama.Style.BRIGHT + colorama.Fore.GREEN

RESET_ALL = colorama.Style.RESET_ALL


def run():
    """Reads input, finds the path, and shows it and its cost."""
    colorama.init()
    print(RESET_ALL, end='')

    grid = Grid(map(str.strip, fileinput.input()))
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
