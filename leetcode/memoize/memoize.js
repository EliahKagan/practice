// LeetCode #2623 - Memoize
// https://leetcode.com/problems/memoize/

/**
 * @param {Function} fn
 */
function memoize(fn) {
    const memo = new Map();

    return (...args) => {
        const key = JSON.stringify(args);

        if (memo.has(key)) {
            return memo.get(key);
        }

        const value = fn(...args);
        memo.set(key, value);
        return value;
    };
}

/**
 * let callCount = 0;
 * const memoizedFn = memoize(function (a, b) {
 *	 callCount += 1;
 *   return a + b;
 * })
 * memoizedFn(2, 3) // 5
 * memoizedFn(2, 3) // 5
 * console.log(callCount) // 1
 */
