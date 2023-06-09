// LeetCode #2635 - Apply Transform Over Each Element in Array
// https://leetcode.com/problems/apply-transform-over-each-element-in-array/

/**
 * @param {number[]} arr
 * @param {Function} fn
 * @return {number[]}
 */
function map(arr, fn) {
    const ret = [];
    for (const [index, elem] of arr.entries()) {
        ret.push(fn(elem, index));
    }
    return ret;
}
