#!/usr/bin/env python3

"""
Jim and his LAN Party
https://www.hackerrank.com/challenges/jim-and-his-lan-party
"""

import itertools

NOT_CONNECTED = -1


class Network:
    """
    A network of elements representing users or machines, each of whom is a
    member of exactly one group, which can meet/play when all members are
    connected in a component (possibly shared with members of other groups).
    """

    __slots__ = (
        '_time',
        '_group_sizes',
        '_group_completion_times',
        '_elem_contributions',
        '_elem_parents',
        '_elem_ranks',
    )

    def __init__(self, group_count, element_groups):
        """
        Creates a new network with groups [0, group_count) and elements in
        [0, element_groups.size). Element i is a member of element_groups[i].
        """
        element_groups = tuple(element_groups)
        total_size = len(element_groups)

        self._time = 0

        self._group_sizes = [0] * group_count
        for group in element_groups:
            self._group_sizes[group] += 1

        self._group_completion_times = [
            self._time if size < 2 else NOT_CONNECTED
            for size in self._group_sizes
        ]

        self._elem_contributions = [
            ({group: 1}
             if self._group_completion_times[group] == NOT_CONNECTED
             else None)
            for group in element_groups
        ]

        self._elem_parents = list(range(total_size))
        self._elem_ranks = [0] * total_size

    @property
    def completion_times(self):
        """
        Retrieves the times at which each group finished becoming connected.
        For groups that were never connected, NOT_CONNECTED is returned.
        """
        return (time for time in self._group_completion_times)

    def connect(self, elem1, elem2):
        """Adds an edge/wire connecting elem1 and elem2."""
        self._time += 1

        # Find the ancestors and stop if they are already the same.
        elem1 = self._find_set(elem1)
        elem2 = self._find_set(elem2)
        if elem1 == elem2:
            return

        # Union by rank, merging contributions.
        if self._elem_ranks[elem1] < self._elem_ranks[elem2]:
            self._join(parent=elem2, child=elem1)
        else:
            if self._elem_ranks[elem1] == self._elem_ranks[elem2]:
                self._elem_ranks[elem1] += 1
            self._join(parent=elem1, child=elem2)

    def _find_set(self, elem):
        """Union-find "findset" operation with full path compression."""
        # Find the ancestor.
        leader = elem
        while leader != self._elem_parents[leader]:
            leader = self._elem_parents[leader]

        # Compress the path.
        while elem != leader:
            parent = self._elem_parents[elem]
            self._elem_parents[elem] = leader
            elem = parent

        return leader

    def _join(self, *, parent, child):
        """Joins child to parent and merges their contributions in parent."""
        self._elem_parents[child] = parent

        self._elem_contributions[parent] = self._merge_contributions(
                                            self._elem_contributions[parent],
                                            self._elem_contributions[child])
        self._elem_contributions[child] = None

    def _merge_contributions(self, contrib1, contrib2):
        """
        Merges contributions into whichever contribution dict started out
        larger, recording and removing items that become complete as a result.
        Returns the resulting dict, or None if that dict is ultimately empty.
        """
        # If either or both are None, there is nothing to do.
        if contrib1 is None:
            return contrib2
        if contrib2 is None:
            return contrib1

        # Merge to the bigger one (so we loop over the smaller).
        if len(contrib1) < len(contrib2):
            return self._do_merge_contributions(sink=contrib2, source=contrib1)
        return self._do_merge_contributions(sink=contrib1, source=contrib2)

    def _do_merge_contributions(self, *, sink, source):
        """Merges the source into the sink. Helper for _merge_contributions."""
        for group, source_count in source.items():
            try:
                sink_count = sink[group]
            except KeyError:
                sink[group] = source_count
                continue

            if sink_count + source_count < self._group_sizes[group]:
                sink[group] = sink_count + source_count
            else:
                del sink[group]
                self._group_completion_times[group] = self._time

        return sink or None


def read_record():
    """Reads a line as a sequence of integers."""
    return map(int, input().split())


def run():
    """"Solves one instance of the problem (read from stdin)."""
    # Read the problem parameters. (_player_count is currently not checked.)
    _player_count, game_count, wire_count = read_record()

    # Make the LAN. The extra 0 element and 0 group are for 1-based indexing.
    network = Network(game_count + 1, itertools.chain((0,), read_record()))

    # Read and apply all the connections.
    for _ in range(wire_count):
        network.connect(*read_record())

    # Skip the extra 0 group and print the other groups' completion times.
    time_iter = iter(network.completion_times)
    next(time_iter)
    for time in time_iter:
        print(time)


if __name__ == '__main__':
    run()
