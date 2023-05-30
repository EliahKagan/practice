// LeetCode #1 - Two Sum
// https://leetcode.com/problems/two-sum/
// By sorting, O(n log n) time.

#define DESTROY(p) do { free(p); p = NULL; } while (false)

static void *xcalloc(size_t num, size_t size)
{
    void *const p = calloc(num, size);
    if (!p) abort();
    return p;
}

static int *iota(const int count)
{
    int *const indices = xcalloc(count, sizeof(*indices));
    for (int index = 0; index < count; ++index) indices[index] = index;
    return indices;
}

static int compare_indices(const void *const lhs_index_p,
                           const void *const rhs_index_p,
                           void *const context)
{
    const int *const nums = (const int *)context;
    const int lhs = nums[*(const int *)lhs_index_p];
    const int rhs = nums[*(const int *)rhs_index_p];

    if (lhs < rhs) return -1;
    if (lhs > rhs) return 1;
    return 0;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(int *restrict const nums, const int numsSize,
            const int target, int *restrict const returnSize)
{
    int *restrict indices = iota(numsSize);
    qsort_r(indices, numsSize, sizeof(*indices), compare_indices, nums);

    int left = 0, right = numsSize - 1;

    while (left < right) {
        const int sum = nums[indices[left]] + nums[indices[right]];

        if (sum < target) {
            ++left;
        } else if (sum > target) {
            --right;
        } else {
            break;
        }
    }

    if (left >= right) abort(); // Not found (violates problem constraints).

    int *const pair = xcalloc(*returnSize = 2, sizeof(*indices));
    pair[0] = indices[left];
    pair[1] = indices[right];
    DESTROY(indices);
    return pair;
}
