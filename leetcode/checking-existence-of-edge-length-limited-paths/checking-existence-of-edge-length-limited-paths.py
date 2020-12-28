# LeetCode 1697 - Checking Existence of Edge Length Limited Paths


class DisjointSets:
    def __init__(self, element_count):
        self._parents = list(range(element_count))
        self._ranks = [0] * element_count

    def find_set(self, elem):
        # Find the ancestor.
        leader = elem
        while leader != self._parents[leader]:
            leader = self._parents[leader]

        # Compress the path.
        while elem != leader:
            parent = self._parents[elem]
            self._parents[elem] = leader
            elem = parent

        return leader

    def union(self, elem1, elem2):
        # Find the ancestors and stop if they are already the same.
        elem1 = self.find_set(elem1)
        elem2 = self.find_set(elem2)
        if elem1 == elem2:
            return

        # Unite by rank.
        if self._ranks[elem1] < self._ranks[elem2]:
            self._parents[elem1] = elem2
        else:
            if self._ranks[elem1] == self._ranks[elem2]:
                self._ranks[elem1] += 1
            self._parents[elem2] = elem1


def weight_or_limit(edge_or_query):
    _, _, wol = edge_or_query
    return wol


def sort_by_weight(edges):
    edges.sort(key=weight_or_limit)


def indices_sorted_by_limit(queries):
    def select(index):
        return weight_or_limit(queries[index])

    return sorted(range(len(queries)), key=select)


class Solution:
    @staticmethod
    def distanceLimitedPathsExist(order: int,
                                  edges: List[List[int]],
                                  queries: List[List[int]]) -> List[bool]:
        sort_by_weight(edges)
        sets = DisjointSets(order)
        results = [None] * len(queries)

        edge_index = 0
        for query_index in indices_sorted_by_limit(queries):
            start, finish, limit = queries[query_index]

            while edge_index < len(edges):
                u, v, weight = edges[edge_index]
                if weight >= limit:
                    break
                sets.union(u, v)
                edge_index += 1

            connected = sets.find_set(start) == sets.find_set(finish)
            results[query_index] = connected

        return results
