#!/usr/bin/env python3
"""
https://www.hackerrank.com/challenges/rust-murderer

In Python 3. Using BFS and an adjacency list in which each row is a frozenset
of forward *non*-neighbors.
"""

import collections
import sys


def read_value():
    """Reads a line as a single integer."""
    return int(input())


def read_record():
    """Reads a line as a sequence of integers."""
    return map(int, input().split())


def read_graph():
    """Reads a graph as an adjacency list."""
    vertex_count, edge_count = read_record()
    if vertex_count < 0:
        raise ValueError("can't have negatively many vertices")
    if edge_count < 0:
        raise ValueError("can't have negatively many edges")

    adj = [[] for _ in range(vertex_count + 1)]  # +1 for 1-based indexing

    def range_check(vertex):
        if not 0 < vertex <= vertex_count:
            raise ValueError('edge specifies vertex not in graph')

    for _ in range(edge_count):
        u, v = read_record()
        range_check(u)
        range_check(v)

        adj[u].append(v)
        adj[v].append(u)

    return tuple(map(frozenset, adj))


VertexCostPair = collections.namedtuple('VertexCostPair', ('vertex', 'cost'))

VertexCostPair.__doc__ = """
A vertex in a graph, and the minimum cost to get there.
"""


def bfs_complement(adj, start):
    """
    Computes minimum-cost paths from the specified start vertex to all other
    vertices, in the "complement" graph that has the same vertices as those in
    the specified graph, and all the edges the specified graph does *not* have.
    Takes every edge weight to be 1.
    """
    assert 0 < start < len(adj) # have unused adj[0] (1-based indexing)

    dests = list(range(1, start)) + list(range(start + 1, len(adj)))
    costs = [None] * len(adj)
    costs[start] = 0

    if not dests:
        return costs

    queue = collections.deque((VertexCostPair(start, 0),))

    while queue:
        src, cost = queue.popleft()
        row = adj[src]

        index = 0
        while index != len(dests):
            dest = dests[index]
            if dest in row:  # Can't go directly to dest: it's a non-neigbor.
                index += 1
                continue

            costs[dest] = cost + 1
            queue.append(VertexCostPair(dest, cost + 1))

            dests[index] = dests[-1]
            del dests[-1]
            if not dests:
                return costs

    print('warning: some vertices were not reached', file=sys.stderr)
    return costs


def report(costs, start):
    """
    Reports the costs of all minimum-cost paths from start, except to itself.
    """
    costs_to_report = costs[1:start] + costs[(start + 1):]
    print(*costs_to_report)


def run():
    """Reads input for, and output the solution of, a single test case."""
    adj = read_graph()
    start = read_value()
    if not 0 < start < len(adj):
        raise ValueError('start vertex is not in graph')

    costs = bfs_complement(adj, start)
    report(costs, start)


if __name__ == '__main__':
    for _ in range(read_value()):
        run()
