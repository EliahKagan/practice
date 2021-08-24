# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By quicksort, with Lomuto partitioning, with random pivot selection.


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        quicksort(nums, 0, len(nums))
        return nums


def quicksort(nums, low, high):
    if high - low > 1:
        mid = lomuto_partition(nums, low, high)
        quicksort(nums, low, mid)
        quicksort(nums, mid + 1, high)


def lomuto_partition(nums, low, high):
    swap_random_to_front(nums, low, high)
    pivot = nums[low]
    mid = low

    for cur in range(low + 1, high):
        if nums[cur] < pivot:
            mid += 1
            nums[mid], nums[cur] = nums[cur], nums[mid]

    nums[low], nums[mid] = nums[mid], nums[low]
    return mid


def swap_random_to_front(nums, low, high):
    index = random.randrange(low, high)
    nums[low], nums[index] = nums[index], nums[low]
