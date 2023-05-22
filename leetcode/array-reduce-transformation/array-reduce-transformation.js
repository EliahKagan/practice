// LeetCode #2626 - Array Reduce Transformation
// https://leetcode.com/problems/array-reduce-transformation/

/**
 * @param {number[]} nums
 * @param {Function} fn
 * @param {number} init
 * @return {number}
 */
function reduce(nums, fn, init) {
    for (const elem of nums) {
        init = fn(init, elem);
    }
    return init;
}
