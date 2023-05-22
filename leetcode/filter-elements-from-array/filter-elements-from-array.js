// LeetCode #2634 - Filter Elements from Array
// https://leetcode.com/problems/filter-elements-from-array/

/**
 * @param {number[]} arr
 * @param {Function} fn
 * @return {number[]}
 */
function filter (arr, fn) {
    const ret = [];
    for (const [index, elem] of arr.entries()) {
        if (fn(elem, index)) {
            ret.push(elem);
        }
    }
    return ret;
}
