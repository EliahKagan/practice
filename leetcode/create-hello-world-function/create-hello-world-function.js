// LeetCode #2667 - Create Hello World Function
// https://leetcode.com/problems/create-hello-world-function/

/**
 * @return {Function}
 */
function createHelloWorld() {
    return (...args) => 'Hello World';
}

/**
 * const f = createHelloWorld();
 * f(); // "Hello World"
 */
