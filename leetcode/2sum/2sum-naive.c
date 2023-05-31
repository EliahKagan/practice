// LeetCode #1 - Two Sum
// https://leetcode.com/problems/two-sum/
// Naive solution, O(n**2) time.

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr) abort();
    return ptr;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(const int *restrict const nums, const int numsSize,
            const int target, int *restrict const returnSize)
{
    int *const pair = xcalloc(*returnSize = 2, sizeof(*pair));

    for (int left = 0; left < numsSize - 1; ++left) {
        for (int right = left + 1; right < numsSize; ++right) {
            if (nums[left] + nums[right] == target) {
                pair[0] = left;
                pair[1] = right;
                return pair;
            }
        }
    }

    abort(); // Not found, which violates the problem constraints.
}
