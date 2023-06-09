// LeetCode #2630 - Memoize II
// https://leetcode.com/problems/memoize-ii/
// Flat approach, mapping each value to a number and building group keys.

/**
 * @param {Function} fn
 */
function memoize(fn) {
    const individuals = new Map(); // arg -> number

    const getIndividual = arg => {
        let number = individuals.get(arg);
        if (number !== undefined) {
            return number;
        }
        number = individuals.size;
        individuals.set(arg, number);
        return number;
    };

    const groups = new Map(); // (...numbers) -> result

    return (...args) => {
        const groupKey = String(args.map(getIndividual));
        if (groups.has(groupKey)) {
            return groups.get(groupKey);
        }
        const result = fn(...args);
        groups.set(groupKey, result);
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
