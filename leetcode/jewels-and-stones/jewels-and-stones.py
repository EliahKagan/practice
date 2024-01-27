# LeetCode #771 - Jewels and Stones

class Solution:
    @staticmethod
    def numJewelsInStones(jewels: str, stones: str) -> int:
        jewel_set = set(jewels)
        return sum(1 for stone in stones if stone in jewel_set)
