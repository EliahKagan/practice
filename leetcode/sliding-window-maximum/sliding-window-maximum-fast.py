# LeetCode #239: Sliding Window Maximum
# https://leetcode.com/problems/sliding-window-maximum/
# Discarding smaller elements that precede larger ones.
# This is also called a "monontonic queue." Takes O(n) time.

class Solution:
    @staticmethod
    def maxSlidingWindow(nums: List[int], k: int) -> List[int]:
        window = collections.deque()

        for index, value in enumerate(nums[:k]):
            while window and nums[window[-1]] < value:
                del window[-1]
            window.append(index)

        maxima = [nums[window[0]]]

        for left_index, right_value in enumerate(nums[k:]):
            if window[0] == left_index:
                del window[0]

            while window and nums[window[-1]] < right_value:
                del window[-1]
            window.append(left_index + k)  # Append right index.

            maxima.append(nums[window[0]])

        return maxima
