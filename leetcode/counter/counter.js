// LeetCode #2620 - Counter
// https://leetcode.com/problems/counter/

/**
 * @param {number} n
 * @return {Function} counter
 */
function createCounter(n) {
    return () => n++;
}

/**
 * const counter = createCounter(10)
 * counter() // 10
 * counter() // 11
 * counter() // 12
 */
