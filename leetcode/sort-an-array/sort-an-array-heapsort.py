# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By heapsort.


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        heapsort(nums)
        return nums


def heapsort(nums):
    if len(nums) < 2:
        return

    heapify(nums)

    for stop in range(len(nums) - 1, 0, -1):
        nums[0], nums[stop] = nums[stop], nums[0]
        sift_down(nums, 0, stop)


def heapify(nums):
    for parent in range(len(nums) // 2 - 1, -1, -1):
        sift_down(nums, parent, len(nums))


def sift_down(nums, parent, stop):
    while True:
        left = parent * 2 + 1
        if left >= stop:
            break

        right = left + 1
        child = right if right != stop and nums[right] > nums[left] else left
        if nums[parent] >= nums[child]:
            break

        nums[parent], nums[child] = nums[child], nums[parent]
        parent = child
