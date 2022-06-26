// Kruskal (MST): Really Special Subtree - Kruskal's algorithm
// https://www.hackerrank.com/challenges/kruskalmstrsub

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

// Allocates num elements of size size. Abort the program on failure.
static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (!ptr) abort();
    return ptr;
}

// Disjoint-set data structure for union-find.
struct uf {
    int *parents;
    int *ranks;
    int element_count;
};

// Creates a union-find data structure, making element_count singletons.
// To clean up, a call to uf_create should be paired with a call to uf_destroy.
static void uf_create(struct uf *const ufp, const int element_count)
{
    assert(element_count >= 0);

    ufp->parents = xcalloc((size_t)element_count, sizeof *ufp->parents);
    ufp->ranks = xcalloc((size_t)element_count, sizeof *ufp->parents);
    ufp->element_count = element_count;

    for (int elem = 0; elem != element_count; ++elem)
        ufp->parents[elem] = elem;
}

// Destroys a union-find data structure, freeing its resources.
static void uf_destroy(struct uf *const ufp)
{
    free(ufp->parents);
    ufp->parents = NULL;

    free(ufp->ranks);
    ufp->ranks = NULL;

    ufp->element_count = 0;
}

// Recursive findset routine. This is an implementation detail of uf_findset.
static int uf_detail_findset(const struct uf *const ufp, const int elem)
{
    if (elem != ufp->parents[elem])
        ufp->parents[elem] = uf_detail_findset(ufp, ufp->parents[elem]);

    return ufp->parents[elem];
}

// Finds the representative of the set containing elem.
static int uf_findset(const struct uf *const ufp, const int elem)
{
    assert(0 <= elem && elem < ufp->element_count);
    return uf_detail_findset(ufp, elem);
}

// Unites elem1 and elem2's sets by rank. Return true iff they were different.
static bool uf_union(const struct uf *const ufp, int elem1, int elem2)
{
    // Find the ancestors and stop if they are already the same.
    elem1 = uf_findset(ufp, elem1);
    elem2 = uf_findset(ufp, elem2);
    if (elem1 == elem2) return false;

    // Union by rank.
    if (ufp->ranks[elem1] < ufp->ranks[elem2]) {
        ufp->parents[elem1] = elem2;
    } else {
        if (ufp->ranks[elem1] == ufp->ranks[elem2]) ++ufp->ranks[elem1];
        ufp->parents[elem2] = elem1;
    }

    return true;
}

// A weighted edge in an undirected graph.
struct edge {
    int u;
    int v;
    int weight;
};

// Comparison function for sorting edges by weight via qsort.
static int edge_compare_by_weight(const void *const lvp, const void *const rvp)
{
    const struct edge *const lp = (const struct edge *)lvp;
    const struct edge *const rp = (const struct edge *)rvp;
    return lp->weight - rp->weight; // Won't overflow, due to small range.
}

// Reads the specified number of edges from standard input.
// To clean up, a call to read_edges should be paired with a call to free.
static struct edge *read_edges(const int edge_count)
{
    assert(edge_count >= 0);

    struct edge *const edges = xcalloc((size_t)edge_count, sizeof *edges);

    for (struct edge *ep = edges; ep != edges + edge_count; ++ep)
        scanf("%d%d%d", &ep->u, &ep->v, &ep->weight);

    return edges;
}

// Finds MST/MSF total weight from sorted edges and singletons of vertices.
static int compute_cost_to_connect(const struct edge *restrict const edges,
                                   const int edge_count,
                                   const struct uf *restrict const ufp)
{
    int acc = 0;

    for (const struct edge *ep = edges; ep != edges + edge_count; ++ep)
        if (uf_union(ufp, ep->u, ep->v)) acc += ep->weight;

    return acc;
}

int main(void)
{
    int vertex_count = 0, edge_count = 0;
    scanf("%d%d", &vertex_count, &edge_count);

    struct edge *edges = read_edges(edge_count);
    qsort(edges, (size_t)edge_count, sizeof *edges, edge_compare_by_weight);

    struct uf sets = {0};
    uf_create(&sets, vertex_count + 1);

    printf("%d\n", compute_cost_to_connect(edges, edge_count, &sets));

    uf_destroy(&sets);

    free(edges);
    edges = NULL;
}
