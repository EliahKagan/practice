// LeetCode #547 - Number of Provinces
// https://leetcode.com/problems/number-of-provinces/
// Iteratively, by stack-based search.

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr && num != 0 && size != 0) abort();
    return ptr;
}

static void *xrealloc(void *const ptr, const size_t new_size)
{
    void *const new_ptr = realloc(ptr, new_size);
    if (!new_ptr && new_size != 0) abort();
    return new_ptr;
}

struct stack {
    int *elems;
    int size;
    int capacity;
};

static void stack_free(struct stack *const sp)
{
    free(sp->elems);
    sp->elems = NULL;
    sp->size = sp->capacity = 0;
}

static inline bool stack_empty(const struct stack *const sp)
{
    return sp->size == 0;
}

static void stack_detail_grow(struct stack *const sp)
{
    enum { initial_nonzero_capacity = 1 };

    if (sp->capacity == 0) {
        sp->capacity = initial_nonzero_capacity;
    } else {
        sp->capacity *= 2;
    }

    sp->elems = xrealloc(sp->elems, sp->capacity * sizeof(*sp->elems));
}

static inline void stack_push(struct stack *const sp, const int value)
{
    if (sp->size == sp->capacity) stack_detail_grow(sp);
    sp->elems[sp->size++] = value;
}

static inline int stack_pop(struct stack *const sp)
{
    assert(!stack_empty(sp));
    return sp->elems[--sp->size];
}

static void dfs(const int *restrict const *restrict const matrix,
                bool *restrict const vis,
                const int vertex_count,
                const int start)
{
    vis[start] = true;
    struct stack fringe = { 0 };
    stack_push(&fringe, start);

    while (!stack_empty(&fringe)) {
        const int src = stack_pop(&fringe);

        for (int dest = 0; dest < vertex_count; ++dest) {
            if (!matrix[src][dest] || vis[dest]) continue;
            vis[dest] = true;
            stack_push(&fringe, dest);
        }
    }

    stack_free(&fringe);
}

static int count_components(const int *const *const matrix,
                            const int vertex_count)
{
    int component_count = 0;
    bool *const vis = xcalloc(vertex_count, sizeof(*vis));

    for (int start = 0; start < vertex_count; ++start) {
        if (vis[start]) continue;
        dfs(matrix, vis, vertex_count, start);
        ++component_count;
    }

    free(vis);
    return component_count;
}

int findCircleNum(const int *restrict const *restrict const isConnected,
                  const int isConnectedSize,
                  const int *restrict const isConnectedColSize)
{
    (void)isConnectedColSize; // Unused, as all must equal isConnectedSize.
    return count_components(isConnected, isConnectedSize);
}
