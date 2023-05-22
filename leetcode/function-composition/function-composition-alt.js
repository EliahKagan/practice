// LeetCode #2629 - Function Composition
// https://leetcode.com/problems/function-composition/

/**
 * @param {Function[]} functions
 * @return {Function}
 */
function compose(functions) {
    return x => {
        for (let index = functions.length - 1; index >= 0; --index) {
            x = functions[index](x);
        }
        return x;
    };
}

/**
 * const fn = compose([x => x + 1, x => 2 * x])
 * fn(4) // 9
 */
