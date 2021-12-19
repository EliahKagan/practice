#!/usr/bin/env python

"""
Advent of Code 2018, day 7, part A

Lexicographically minimal topological sort, storing roots (as they are
discovered) in a binary minheap.
"""

from __future__ import annotations

import fileinput
import heapq
import re
from typing import Any, Generic, Iterable, Mapping, TypeVar

import attr
from typeguard import typechecked


T = TypeVar('T')  # pylint: disable=invalid-name


@typechecked
def _get_zeros(mapping: Mapping[T, Any]) -> list[T]:
    """Returns the keys that are mapped to falsy values in the mapping."""
    return [key for key, value in mapping.items() if not value]


@attr.s(frozen=True, slots=True, auto_attribs=True)
class Edge(Generic[T]):
    """A directed edge."""

    src: T
    """The source (tail) vertex."""

    dest: T
    """The destination (head) vertex."""


@typechecked
class Graph(Generic[T]):
    """An unweighted directed graph, representing dependencies."""

    __slots__ = ('_adj', '_indegrees')

    _adj: dict[T, list[T]]
    _indegrees: dict[T, int]

    @classmethod
    def from_edges(cls, edges: Iterable[Edge[T]]) -> Graph[T]:
        """Creates a directed graph from an iterable of edges."""
        graph = cls()
        for edge in edges:
            graph.add_edge(edge.src, edge.dest)
        return graph

    def __init__(self):
        """Creates an initially empty directed graph."""
        self._adj = {}
        self._indegrees = {}

    @property
    def order(self) -> int:
        """The number of vertices in the graph."""
        return len(self._adj)

    def add_vertex(self, vertex: T) -> None:
        """Adds a vertex to the graph, if it is not already present."""
        if vertex not in self._adj:
            self._adj[vertex] = []
            self._indegrees[vertex] = 0

    def add_edge(self, src: T, dest: T) -> None:
        """
        Adds a directed edge to the graph.

        If one or both vertices are not in the graph, they are added too.
        If this edge already exists in the graph, a parallel edge is added.
        """
        self.add_vertex(src)
        self.add_vertex(dest)
        self._adj[src].append(dest)
        self._indegrees[dest] += 1

    def toposort(self) -> list[T]:
        """
        Emits a lexicographically minimal topological sort.

        Raises ValueError if the graph is cyclic.
        """
        indegrees = self._indegrees.copy()
        roots = _get_zeros(indegrees)
        heapq.heapify(roots)
        out = []

        while roots:
            src = heapq.heappop(roots)
            out.append(src)
            for dest in self._adj[src]:
                indegrees[dest] -= 1
                if indegrees[dest] == 0:
                    heapq.heappush(roots, dest)

        if len(out) != self.order:
            raise ValueError('cyclic graph has no topological ordering')

        return out


_STEP_PARSER = re.compile(
    r'^Step (\w+) must be finished before step (\w+) can begin\.$')


@typechecked
def read_edges() -> Iterable[Edge[str]]:
    """Reads steps from stdin or a file as directed edges."""
    raw_lines: Iterable[str] = fileinput.input()

    for line in map(str.strip, raw_lines):
        if not line:
            continue

        match = _STEP_PARSER.fullmatch(line)
        if match is None:
            raise ValueError(f'malformed line: {line}')

        yield Edge[str](*match.groups())


@typechecked
def run() -> None:
    """Reads steps from stdin or a file. Outputs the appropriate ordering."""
    sequence = Graph.from_edges(read_edges()).toposort()

    if any(len(vertex) != 1 for vertex in sequence):
        print(sequence)
    else:
        print(''.join(sequence))


if __name__ == '__main__':
    run()
