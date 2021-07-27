// LeetCode #15 - 3Sum
// https://leetcode.com/problems/3sum/
// By two pointers, repeated for each suffix, avoiding duplicates.

class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        Arrays.sort(nums);
        List<List<Integer>> triplets = new ArrayList<>();

        for (var i = 0; i < nums.length - 2; ) {
            var first = nums[i];

            for (var pair : twoSum(nums, i + 1, -first))
                triplets.add(List.of(nums[i], pair[0], pair[1]));

            while (i < nums.length - 2 && nums[i] == first) ++i;
        }

        return triplets;
    }

    private static List<int[]> twoSum(int[] nums, int left, int target) {
        List<int[]> pairs = new ArrayList<>();

        for (var right = nums.length - 1; left < right; ) {
            var first = nums[left];
            var second = nums[right];

            if (first + second == target)
                pairs.add(new int[] { first, second });

            if (first + second <= target)
                while (left < right && nums[left] == first) ++left;

            if (first + second >= target)
                while (left < right && nums[right] == second) --right;
        }

        return pairs;
    }
}
