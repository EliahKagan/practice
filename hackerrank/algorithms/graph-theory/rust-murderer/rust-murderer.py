#!/usr/bin/env python3

import collections
import itertools
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

    for row in adj:
        row.sort()

    return adj


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
    assert adj  # adj[0] exists and is unused (1-based indexing)
    remaining = len(adj) - 1
    costs = [None] * len(adj)
    queue = collections.deque()

    def visit(vertex, cost):
        """Visits vertex. Records cost. Returns True iff BFS is finished."""
        nonlocal remaining

        costs[vertex] = cost
        remaining -= 1
        if not remaining:
            return True
        queue.append(VertexCostPair(vertex, cost))
        return False

    if visit(start, 0):
        return costs

    while queue:
        src, cost = queue.popleft()

        row = adj[src]
        nei_index = 0
        nei_stop = len(row)

        for dest in range(1, len(adj)):
            leader = nei_index
            while leader != nei_stop and row[leader] == dest:
                leader += 1

            if nei_index != leader:
                nei_index = leader
            elif costs[dest] is None and visit(dest, cost + 1):
                print(costs, file=sys.stderr)
                return costs

    print('warning: some vertices were not reached', file=sys.stderr)
    return costs


def report(costs, start):
    """
    Reports the costs of all minimum-cost paths from start, except to itself.
    """
    print(*itertools.chain(range(1, start), range(start + 1, len(costs))))


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
