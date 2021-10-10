// LeetCode #189 - Rotate Array
// https://leetcode.com/problems/rotate-array/
// Using O(1) auxiliary space.

class Solution {
    public void rotate(int[] nums, int k) {
        var brk = nums.length - k % nums.length;
        reverse(nums, 0, brk);
        reverse(nums, brk, nums.length);
        reverse(nums, 0, nums.length);
    }

    private static void reverse(int[] nums, int start, int end) {
        for (; start < --end; ++start) swap(nums, start, end);
    }

    private static void swap(int[] nums, int i, int j) {
        var tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
