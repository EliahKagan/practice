// LeetCode #2666 - Allow One Function Call
// https://leetcode.com/problems/allow-one-function-call/

/**
 * @param {Function} fn
 * @return {Function}
 */
function once(fn) {
    let called = false;

    return (...args) => {
        if (called) return undefined;
        called = true;
        return fn(...args);
    };
};

/**
 * let fn = (a,b,c) => (a + b + c)
 * let onceFn = once(fn)
 *
 * onceFn(1,2,3); // 6
 * onceFn(2,3,6); // returns undefined without calling fn
 */
