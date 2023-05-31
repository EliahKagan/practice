// LeetCode #1 - Two Sum
// https://leetcode.com/problems/two-sum/
// By hashing, O(n) time with high probability.

struct node {
    UT_hash_handle hh;
    int num;
    int left_index;
};

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr) abort();
    return ptr;
}

static void free_table(struct node **const nodesp)
{
    struct node *node = NULL, *tmp = NULL;

    HASH_ITER(hh, *nodesp, node, tmp) {
        HASH_DEL(*nodesp, node);
        free(node);
    }
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* twoSum(const int *restrict const nums, const int numsSize,
            const int target, int *restrict const returnSize)
{
    struct node *nodes = NULL;
    int left_index = -1, right_index = -1;

    for (int index = 0; index < numsSize; ++index) {
        // Search for the complement.
        const int complement = target - nums[index];
        struct node *complement_node = NULL;
        HASH_FIND_INT(nodes, &complement, complement_node);

        // If the complement is found, we have our two-sum pair.
        if (complement_node) {
            left_index = complement_node->left_index;
            right_index = index;
            break;
        }

        // Check if this element is a duplicate.
        struct node *element_node = NULL;
        HASH_FIND_INT(nodes, &nums[index], element_node);
        if (element_node) continue;

        // If this element is not a duplicate, remember it.
        element_node = xcalloc(1, sizeof(*element_node));
        element_node->num = nums[index];
        element_node->left_index = index;
        HASH_ADD_INT(nodes, num, element_node);
    }

    free_table(&nodes);

    if (left_index == -1) abort(); // Not found (violates problem constraints).

    int *const pair = xcalloc(*returnSize = 2, sizeof(*pair));
    pair[0] = left_index;
    pair[1] = right_index;
    return pair;
}
