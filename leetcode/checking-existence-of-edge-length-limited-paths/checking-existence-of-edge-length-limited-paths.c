// LeetCode 1697 - Checking Existence of Edge Length Limited Paths

void qsort_r(void *base, size_t nmemb, size_t size,
             int (*compar)(const void *, const void *, void *),
             void *arg);

static void ensure(bool condition)
{
    if (!condition) abort();
}

static void *xcalloc(const size_t num, const size_t size)
{
    assert(num != 0);
    assert(size != 0);

    void *const p = calloc(num, size);
    ensure(p);
    return p;
}

static int *zeros(const int num)
{
    assert(num > 0);

    int *const p = xcalloc(num, sizeof *p);
    return p;
}

static int *iota(const int num)
{
    assert(num > 0);

    int *const p = xcalloc(num, sizeof *p);
    for (int i = 0; i < num; ++i) p[i] = i;
    return p;
}

static inline void destroy(int **const pp)
{
    free(*pp);
    *pp = NULL;
}

struct uf {
    int *parents;
    int *ranks;
    int element_count;
};

static struct uf uf_makesets(const int element_count)
{
    assert(element_count > 0);

    struct uf uf = { 0 };
    uf.parents = iota(element_count);
    uf.ranks = zeros(element_count);
    uf.element_count = element_count;
    return uf;
}

static void uf_destroy(struct uf *const ufp)
{
    assert(ufp);

    destroy(&ufp->parents);
    destroy(&ufp->ranks);
    ufp->element_count = 0;
}

static inline bool uf_detail_exists(const struct uf *const ufp, const int elem)
{
    assert(ufp);

    return 0 <= elem && elem < ufp->element_count;
}

static int uf_findset(const struct uf *const ufp, int elem)
{
    assert(ufp);
    assert(uf_detail_exists(ufp, elem));

    // Find the ancestor.
    int leader = elem;
    while (leader != ufp->parents[leader]) leader = ufp->parents[leader];

    // Compress the path.
    while (elem != leader) {
        const int parent = ufp->parents[elem];
        ufp->parents[elem] = leader;
        elem = parent;
    }

    return leader;
}

static void uf_union(const struct uf *const ufp, int elem1, int elem2)
{
    assert(ufp);
    assert(uf_detail_exists(ufp, elem1));
    assert(uf_detail_exists(ufp, elem2));

    // Find the ancestors and stop if they are already the same.
    elem1 = uf_findset(ufp, elem1);
    elem2 = uf_findset(ufp, elem2);
    if (elem1 == elem2) return;

    // Unite by rank.
    if (ufp->ranks[elem1] < ufp->ranks[elem2]) {
        ufp->parents[elem1] = elem2;
    } else {
        if (ufp->ranks[elem1] == ufp->ranks[elem2]) ++ufp->ranks[elem1];
        ufp->parents[elem2] = elem1;
    }
}

static inline int endpoint1(const int *const edge)
{
    return edge[0];
}

static inline int endpoint2(const int *const edge)
{
    return edge[1];
}

static inline int weight_or_limit(const int *const edge)
{
    return edge[2];
}

static inline int intcmp(const int lhs, const int rhs)
{
    if (lhs < rhs) return -1;
    if (lhs > rhs) return +1;
    return 0;
}

static int compare_by_weight(const void *const lhs, const void *const rhs)
{
    int *const *const ledgep = lhs;
    int *const *const redgep = rhs;

    const int lweight = weight_or_limit(*ledgep);
    const int rweight = weight_or_limit(*redgep);

    return intcmp(lweight, rweight);
}

static void sort_by_weight(int **const edges, const int edge_count)
{
    qsort(edges, edge_count, sizeof *edges, compare_by_weight);
}

static int compare_indices_by_limit(const void *const lhs,
                                    const void *const rhs,
                                    void *const context)
{
    const int *const lindexp = lhs;
    const int *const rindexp = rhs;
    int **const queries = context;

    const int llimit = weight_or_limit(queries[*lindexp]);
    const int rlimit = weight_or_limit(queries[*rindexp]);

    return intcmp(llimit, rlimit);
}

static int *indices_sorted_by_limit(int **const queries, const int query_count)
{
    int *const indices = iota(query_count);

    qsort_r(indices, query_count, sizeof *indices,
            compare_indices_by_limit, queries);

    return indices;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
bool *distanceLimitedPathsExist(const int order,
                                int **const edges,
                                int edge_count,
                                int *const edge_record_widths,
                                int **const queries,
                                const int query_count,
                                int *const query_record_widths,
                                int *const result_countp)
{
    (void)edge_record_widths;
    (void)query_record_widths;

    sort_by_weight(edges, edge_count);
    bool *const results = xcalloc(query_count, sizeof *results);
    int *query_indices = indices_sorted_by_limit(queries, query_count);
    struct uf uf = uf_makesets(order);

    int ei = 0;

    for (int qii = 0; qii < query_count; ++qii) {
        const int qi = query_indices[qii];
        const int limit = weight_or_limit(queries[qi]);

        while (ei < edge_count && weight_or_limit(edges[ei]) < limit) {
            const int u = endpoint1(edges[ei]);
            const int v = endpoint2(edges[ei]);
            uf_union(&uf, u, v);
            ++ei;
        }

        const int start = endpoint1(queries[qi]);
        const int finish = endpoint2(queries[qi]);
        results[qi] = uf_findset(&uf, start) == uf_findset(&uf, finish);
    }

    uf_destroy(&uf);
    destroy(&query_indices);
    *result_countp = query_count;
    return results;
}
