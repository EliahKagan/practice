// LeetCode 167 - Two Sum II - Input Array Is Sorted
// https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/

impl Solution {
    pub fn two_sum(numbers: Vec<i32>, target: i32) -> Vec<i32> {
        let mut left = 0;
        let mut right = numbers.len() - 1;

        while left < right {
            let sum = numbers[left] + numbers[right];
            if sum < target {
                left += 1;
            } else if sum > target {
                right -= 1;
            } else {
                return vec![left as i32 + 1, right as i32 + 1];
            }
        }

        panic!("no solution");
    }
}
