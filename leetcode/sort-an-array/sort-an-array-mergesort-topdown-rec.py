# LeetCode #912 - Sort an Array
# https://leetcode.com/problems/sort-an-array/
# By recursive top-down mergesort.


class Solution:
    def sortArray(self, nums: List[int]) -> List[int]:
        mergesort(nums, 0, len(nums), [])
        return nums


def mergesort(nums, low, high, aux):
    length = high - low
    if length < 2:
        return

    mid = low + length // 2
    mergesort(nums, low, mid, aux)
    mergesort(nums, mid, high, aux)
    merge(nums, low, mid, high, aux)


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
