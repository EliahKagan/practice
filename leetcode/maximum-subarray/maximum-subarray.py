# LeetCode #53 - Maximum Subarray
# https://leetcode.com/problems/maximum-subarray/
# Linear time dynamic programming solution.

class Solution:
    @staticmethod
    def maxSubArray(nums: List[int]) -> int:
        best_sum = current_sum = -math.inf

        for value in nums:
            current_sum = max(current_sum + value, value)
            best_sum = max(best_sum, current_sum)

        if best_sum > -math.inf:
            return best_sum

        raise ValueError('empty sequence has no solution')
