// LeetCode #2629 - Function Composition
// https://leetcode.com/problems/function-composition/

/**
 * @param {Function[]} functions
 * @return {Function}
 */
function compose(functions) {
    return x => functions.reduceRight((acc, fn) => fn(acc), x);
}

/**
 * const fn = compose([x => x + 1, x => 2 * x])
 * fn(4) // 9
 */
