// LeetCode #15 - 3Sum
// https://leetcode.com/problems/3sum/
// By sorting, then n linear "two fingers" passes. O(n**2) time.

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr) abort();
    return ptr;
}

static void *xrealloc(void *const ptr, size_t new_size)
{
    void *const new_ptr = realloc(ptr, new_size);
    if (new_ptr == NULL && new_size != 0) abort();
    return new_ptr;
}

static int compare(const void *const lhsp, const void *const rhsp)
{
    const int lhs = *(const int *)lhsp;
    const int rhs = *(const int *)rhsp;

    if (lhs < rhs) return -1;
    if (lhs > rhs) return 1;
    return 0;
}

struct vec {
    int **triples;
    int size;
    int capacity;
};

static void vec_detail_grow(struct vec *const vecp)
{
    enum { initial_nonzero_capacity = 1 };

    if (vecp->capacity == 0) {
        vecp->capacity = initial_nonzero_capacity;
    } else {
        vecp->capacity *= 2;
    }

    vecp->triples = xrealloc(vecp->triples,
                             vecp->capacity * sizeof(*vecp->triples));
}

static inline int
*vec_detail_make_triple(const int first, const int second, const int third)
{
    int *const triple = xcalloc(3, sizeof(*triple));
    triple[0] = first;
    triple[1] = second;
    triple[2] = third;
    return triple;
}

static void vec_append(struct vec *const vecp,
                       const int first, const int second, const int third)
{
    if (vecp->size == vecp->capacity) vec_detail_grow(vecp);
    vecp->triples[vecp->size++] = vec_detail_make_triple(first, second, third);
}

static int *repeat(const int value, const int count)
{
    int *const repetition = xcalloc(count, sizeof(*repetition));
    for (int index = 0; index < count; ++index) repetition[index] = value;
    return repetition;
}

/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */
int** threeSum(int *restrict const nums, const int numsSize,
               int *restrict const returnSize,
               int *restrict *restrict const returnColumnSizes)
{
    qsort(nums, numsSize, sizeof(*nums), compare);

    struct vec triples = { 0 };

    for (int left = 0; left < numsSize - 2; ) {
        const int left_elem = nums[left];

        for (int mid = left + 1, right = numsSize - 1; mid < right; ) {
            const int mid_elem = nums[mid];
            const int right_elem = nums[right];
            const int sum = left_elem + mid_elem + right_elem;

            if (sum == 0) {
                vec_append(&triples, left_elem, mid_elem, right_elem);
            }
            if (sum <= 0) {
                while (++mid < right && nums[mid] == mid_elem) { }
            }
            if (sum >= 0) {
                while (mid < --right && nums[right] == right_elem) { }
            }
        }

        while (++left < numsSize - 2 && nums[left] == left_elem) { }
    }

    *returnSize = triples.size;
    *returnColumnSizes = repeat(3, triples.size);
    return triples.triples;
}
