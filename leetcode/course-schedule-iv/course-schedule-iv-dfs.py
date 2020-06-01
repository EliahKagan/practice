class Solution:
    @staticmethod
    def checkIfPrerequisite(n: int,
                            prerequisites: List[List[int]],
                            queries: List[List[int]]) -> List[bool]:
        """
        Given a dependency graph of order n described by an edge list
        (prerequisites), answers queries of the form (start, end) to indicate
        if start is a (possibly indirect) dependency of end.
        """
        adj = build_adjacency_list(n, prerequisites)
        return [can_reach(adj, start, end) for start, end in queries]


def build_adjacency_list(order, edges):
    """
    Builds an adjacency list for a directed graph with the given order (number
    of vertices) and edges.
    """
    adj = [[] for _ in range(order)]
    for src, dest in edges:
        adj[src].append(dest)
    return adj


def can_reach(adj, start, end):
    """
    Searches in a graph represented by an adjacency list to determine if there
    is a path from a start vertex to an end vertex.
    """
    vis = [False] * len(adj)

    def dfs(src):
        if vis[src]:
            return False
        vis[src] = True
        return src == end or any(dfs(dest) for dest in adj[src])

    return dfs(start)
