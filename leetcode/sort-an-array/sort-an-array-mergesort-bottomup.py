# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By iterative bottom-up mergesort.


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        mergesort(nums)
        return nums


def mergesort(nums):
    aux = []

    delta = 1
    while delta < len(nums):
        for low in range(0, len(nums) - delta, delta * 2):
            mid = low + delta
            high = min(mid + delta, len(nums))
            merge(nums, low, mid, high, aux)

        delta *= 2


def merge(nums, low, mid, high, aux):
    assert not aux, 'auxiliary storage must start empty'

    left = low
    right = mid

    while left < mid and right < high:
        if nums[right] < nums[left]:
            aux.append(nums[right])
            right += 1
        else:
            aux.append(nums[left])
            left += 1


    aux.extend(nums[left:mid])
    assert len(aux) == right - low, 'wrong length from merge'
    nums[low:right] = aux
    aux.clear()
