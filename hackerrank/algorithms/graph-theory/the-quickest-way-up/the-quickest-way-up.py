#!/usr/bin/env python3

"""
Snakes and Ladders: The Quickest Way Up
https://www.hackerrank.com/challenges/the-quickest-way-up
"""

import collections
import math


class Game:
    """A "Snakes and Ladders" board and die."""

    __slots__ = ('_board', '_max_reach')

    def __init__(self, size, max_reach):
        """Creates a new of the specified board size and die reach."""
        self._board = list(range(size + 1))
        self._max_reach = max_reach

    def add_snake_or_ladder(self, src, dest):
        """Adds a snake or ladder from src to dest. (1-based indexing.)"""
        self._check_index(src)
        self._check_index(dest)

        self._board[src] = dest

    def compute_distance(self, start, finish):
        """Computes the minimum distance from start to finish via BFS."""
        self._check_index(start)
        self._check_index(finish)

        vis = [False] * len(self._board)
        vis[start] = True
        queue = collections.deque((start,))
        distance = 0

        while queue:
            distance += 1

            for _ in range(len(queue)):
                src = queue.popleft()
                for dest in self._destinations(src):
                    if vis[dest]:
                        continue
                    vis[dest] = True
                    if dest == finish:
                        return distance
                    queue.append(dest)

        return math.inf

    def _check_index(self, position):
        """Throws if the position is not of a valid board cell."""
        if not 0 < position < len(self._board):
            raise ValueError('position is off the board')

    def _destinations(self, src):
        """
        Computes destinations from a given source position.
        This accounts for the traversal of snakes and ladders.
        """
        stop = min(src + self._max_reach + 1, len(self._board))
        return (self._board[predest] for predest in range(src + 1, stop))


def read_value():
    """Reads a line as a single integer value."""
    return int(input())


def read_record():
    """Reads a line as a sequence of integers."""
    return map(int, input().split())


def read_snakes_or_ladders(game):
    """Adds snakes or ladders in the input format to a game."""
    for _ in range(read_value()):
        game.add_snake_or_ladder(*read_record())


def run():
    """Reads a board configuration and reports the BFS distance."""
    game = Game(size=100, max_reach=6)
    read_snakes_or_ladders(game)  # ladders
    read_snakes_or_ladders(game)  # snakes
    distance = game.compute_distance(1, 100)
    print(-1 if distance == math.inf else distance)


if __name__ == '__main__':
    for _ in range(read_value()):
        run()
