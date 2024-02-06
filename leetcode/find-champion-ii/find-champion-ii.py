# LeetCode #2924 - Find Champion II

class Solution:
    @staticmethod
    def findChampion(n: int, edges: List[List[int]]) -> int:
        roots = set(range(n)) - {dest for _, dest in edges}
        return roots.pop() if len(roots) == 1 else -1
