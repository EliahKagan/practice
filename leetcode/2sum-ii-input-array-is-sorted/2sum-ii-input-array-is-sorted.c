// LeetCode #167 - Two Sum II - Input Array Is Sorted
// https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/
// By linear "two fingers" pass. O(n) time.

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr) abort();
    return ptr;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(const int *restrict const numbers, const int numbersSize,
            const int target, int *restrict const returnSize)
{
    int left = 0, right = numbersSize - 1;

    while (left < right) {
        const int sum = numbers[left] + numbers[right];

        if (sum < target) {
            ++left;
        } else if (sum > target) {
            --right;
        } else {
            break;
        }
    }

    if (left >= right) abort(); // Not found (violates problem constraints).

    int *const pair = xcalloc(*returnSize = 2, sizeof(*pair));
    pair[0] = left + 1;
    pair[1] = right + 1;
    return pair;
}
