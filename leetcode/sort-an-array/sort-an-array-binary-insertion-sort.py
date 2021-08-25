# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By binary insertion sort. (Not submitted; this algorithm is too slow.)


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        binary_insertion_sort(nums)
        return nums


def binary_insertion_sort(nums):
    for right in range(1, len(nums)):
        dest = upper_bound(nums, right, nums[right])
        for left in range(right, dest, -1):
            nums[left - 1], nums[left] = nums[left], nums[left - 1]


def upper_bound(nums, high, key):
    low = 0

    while low < high:
        mid = (low + high) // 2

        if key < nums[mid]:
            high = mid
        else:
            low = mid + 1

    return low
