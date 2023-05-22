// LeetCode #2630 - Memoize II
// https://leetcode.com/problems/memoize-ii/

/**
 * @param {Function} fn
 */
function memoize(fn) {
    const end = Object.freeze({});
    const trie = new Map();

    return (...args) => {
        let node = trie;

        for (const arg of args) {
            if (node.has(arg)) {
                node = node.get(arg);
            } else {
                const child = new Map();
                node.set(arg, child);
                node = child;
            }
        }

        if (node.has(end)) {
            return node.get(end);
        }

        const result = fn(...args);
        node.set(end, result);
        return result;
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
