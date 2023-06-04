// LeetCode #547 - Number of Provinces
// https://leetcode.com/problems/number-of-provinces/
// By recursive depth-first search (DFS).

static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr && num != 0) abort();
    return ptr;
}

static void dfs(const int *restrict const *restrict const matrix,
                bool *restrict const vis,
                const int vertex_count,
                const int src)
{
    vis[src] = true;

    for (int dest = 0; dest < vertex_count; ++dest) {
        if (matrix[src][dest] && !vis[dest])
            dfs(matrix, vis, vertex_count, dest);
    }
}

static int count_components(const int *restrict const *restrict const matrix,
                            bool *restrict const vis,
                            const int vertex_count)
{
    int component_count = 0;

    for (int start = 0; start < vertex_count; ++start) {
        if (vis[start]) continue;
        dfs(matrix, vis, vertex_count, start);
        ++component_count;
    }

    return component_count;
}

int findCircleNum(const int *restrict const *restrict const isConnected,
                  const int isConnectedSize,
                  const int *restrict const isConnectedColSize)
{
    (void)isConnectedColSize; // Unused, as all must equal isConnectedSize.

    bool *const vis = xcalloc(isConnectedSize, sizeof(*vis));
    const int count = count_components(isConnected, vis, isConnectedSize);
    free(vis);
    return count;
}
