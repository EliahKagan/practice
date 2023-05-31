// LeetCode #16 - 3Sum Closest
// https://leetcode.com/problems/3sum-closest/
// By sorting, then n linear "two fingers" passes. O(n**2) time.

static int compare(const void *const lhsp, const void *const rhsp)
{
    const int lhs = *(const int *)lhsp;
    const int rhs = *(const int *)rhsp;

    if (lhs < rhs) return -1;
    if (lhs > rhs) return 1;
    return 0;
}

int threeSumClosest(int *const nums, const int numsSize, const int target)
{
    qsort(nums, numsSize, sizeof(*nums), compare);

    int best_distance = INT_MAX;
    int best_sum = 0;

    for (int left = 0; left < numsSize - 2; ++left) {
        for (int mid = left + 1, right = numsSize - 1; mid < right; ) {
            const int sum = nums[left] + nums[mid] + nums[right];
            const int delta = sum - target;
            const int distance = abs(delta);

            if (distance < best_distance) {
                best_distance = distance;
                best_sum = sum;
            }

            if (delta < 0) {
                ++mid;
            } else if (delta > 0) {
                --right;
            } else {
                return best_sum;
            }
        }
    }

    return best_sum;
}
