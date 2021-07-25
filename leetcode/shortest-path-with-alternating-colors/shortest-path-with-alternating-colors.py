def build_adjacency_list(order, edges):
    """Builds an adjacency list for a directed graph."""
    adj = [[] for _ in range(order)]

    for src, dest in edges:
        adj[src].append(dest)

    return adj


def shortest_alternating_path_lengths(red_adj, blue_adj):
    """Finds lengths of shortest alternating paths from the 0 vertex."""
    assert len(red_adj) == len(blue_adj)
    lengths = [None] * len(red_adj)
    lengths[0] = 0
    queue = collections.deque(((0, True), (0, False)))  # red edges, blue edges

    for length in itertools.count(1):
        if not queue:
            break

        for _ in range(len(queue)):
            src, src_color = queue.popleft()

            for dest in (red_adj if src_color else blue_adj)[src]:
                if lengths[dest] is not None:
                    continue
                lengths[dest] = length
                queue.append((dest, not src_color))

    return lengths


class Solution:
    @staticmethod
    def shortestAlternatingPaths(order: int,
                                 red_edges: List[List[int]],
                                 blue_edges: List[List[int]]) -> List[int]:
        """Finds and reports lengths of shortest alternating paths from 0."""
        red_adj = build_adjacency_list(order, red_edges)
        blue_adj = build_adjacency_list(order, blue_edges)
        lengths = shortest_alternating_path_lengths(red_adj, blue_adj)

        return [(-1 if length is None else length) for length in lengths]
