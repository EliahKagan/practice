# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By insertion sort. (Not submitted; this algorithm is too slow.)


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        binary_insertion_sort(nums)
        return nums


def insertion_sort(nums):
    for right in range(1, len(nums)):
        for left in range(right, 0, -1):
            if nums[left - 1] <= nums[left]:
                break
            nums[left - 1], nums[left] = nums[left], nums[left - 1]
