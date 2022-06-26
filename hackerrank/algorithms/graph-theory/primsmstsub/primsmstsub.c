// "Prim's (MST) : Special Subtree" on HackerRank
// https://www.hackerrank.com/challenges/primsmstsub
// Using a binary minheap + direct-address table data structure.

#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define DESTROY(ptr) do { free(ptr); (ptr) = NULL; } while(false)

// Allocates num elements of size size. Aborts the program on failure.
static void *xcalloc(const size_t num, const size_t size)
{
    void *const ptr = calloc(num, size);
    if (num != 0 && !ptr) abort();
    return ptr;
}

// Reallocates (or allocates) memory. Aborts the program on failure.
static void *xrealloc(void *const ptr, const size_t new_size)
{
    assert(new_size != 0);

    void *const new_ptr = realloc(ptr, new_size);
    if (!new_ptr) abort();
    return new_ptr;
}

// Sentinel value indicating an invalid index. Implementation detail of pq.
enum { pq_detail_absent = -1 };

// A key-value mapping in a heap+map data structure.
struct pq_entry {
    int key;
    int value;
};

// A binary minheap + direct-address table data structure implementing a
// priority queue suitable for Prim's and Dijkstra's algorithms.
struct pq {
    struct pq_entry *restrict heap;
    int *restrict map;
    int capacity;
    int size;
};

// Creates a new priority queue supporting "keys" 0, ..., capacity - 1.
// To clean up, a pq_create call should be paired with a pq_destroy call.
static void pq_create(struct pq *const pqp, const int capacity)
{
    assert(capacity >= 0);

    pqp->heap = xcalloc((size_t)capacity, sizeof *pqp->heap);
    pqp->map = xcalloc((size_t)capacity, sizeof *pqp->map);
    for (int key = 0; key != capacity; ++key) pqp->map[key] = pq_detail_absent;
    pqp->capacity = capacity;
    pqp->size = 0;
}

// Destroys a priority queue, freeing its resources.
static void pq_destroy(struct pq *const pqp)
{
    DESTROY(pqp->heap);
    DESTROY(pqp->map);
    pqp->capacity = pqp->size = 0;
}

// Checks if a priority queue currently contains no mappings.
static inline bool pq_empty(const struct pq *const pqp)
{
    return pqp->size == 0;
}

// Gets a const pointer to the priority mapping.
static inline const struct pq_entry *pq_peek(const struct pq *const pqp)
{
    assert(pqp->size > 0);
    return pqp->heap;
}

// Records the indexed heap entry in the map. Implementation deail of pq.
static inline void pq_detail_update_map(const struct pq *const pqp,
                                        const int heap_index)
{
    pqp->map[pqp->heap[heap_index].key] = heap_index;
}

// Restores the heap invariant upward. Implementation detail of pq.
static void pq_detail_sift_up(const struct pq *const pqp, int child,
                              const int key, const int value)
{
    while (child != 0) {
        const int parent = (child - 1) / 2;
        if (pqp->heap[parent].value <= value) break;

        pqp->heap[child] = pqp->heap[parent];
        pq_detail_update_map(pqp, child);
        child = parent;
    }

    pqp->heap[child].key = key;
    pqp->heap[child].value = value;
    pq_detail_update_map(pqp, child);
}

// Finds the the smallest-valued child entry. Implementation detail of pq.
static int pq_detail_pick_child(const struct pq *const pqp, const int parent)
{
    const int left = parent * 2 + 1;
    if (left >= pqp->size) return pq_detail_absent;

    const int right = left + 1;
    return right != pqp->size && pqp->heap[right].value < pqp->heap[left].value
            ? right
            : left;
}

// Restores the heap invariant downward. Implementation detail of pq.
static void pq_detail_sift_down(const struct pq *const pqp, int parent,
                                const int key, const int value)
{
    for (; ; ) {
        const int child = pq_detail_pick_child(pqp, parent);
        if (child == pq_detail_absent || value <= pqp->heap[child].value)
            break;

        pqp->heap[parent] = pqp->heap[child];
        pq_detail_update_map(pqp, parent);
        parent = child;
    }

    pqp->heap[parent].key = key;
    pqp->heap[parent].value = value;
    pq_detail_update_map(pqp, parent);
}

// Decreases a key's value, if higher, or add it if absent.
static void pq_push_or_decrease(struct pq *const pqp,
                                const int key, const int value)
{
    assert(pqp->size < pqp->capacity);

    int child = pqp->map[key];

    if (child == pq_detail_absent)
        child = pqp->size++;
    else if (pqp->heap[child].value <= value)
        return;

    pq_detail_sift_up(pqp, child, key, value);
}

// Removes the priority mapping.
static void pq_pop(struct pq *const pqp)
{
    assert(pqp->size > 0);

    pqp->map[pqp->heap[0].key] = pq_detail_absent;

    struct pq_entry *const ep = &pqp->heap[--pqp->size];
    if (pqp->size != 0) pq_detail_sift_down(pqp, 0, ep->key, ep->value);
    ep->key = ep->value = 0; // Zero out the unused space for easier debugging.
}

// An entry in a row of an adjacency list for a weighted graph.
struct out_edge {
    int dest;
    int weight;
};

// The starting capacity of a row.
enum { row_detail_min_capacity = 1 }; // FIXME: After testing, increase this.

// A row in an adjacency list of a weighted graph.
// This is a vector (dynamically expanding array) of out_edge objects.
struct row {
    struct out_edge *elems;
    int capacity;
    int size;
};

// Creates a new row in an adjacency list.
// To clean up, a row_create call should be paired with a row_destroy call.
static void row_create(struct row *const rp)
{
    rp->capacity = row_detail_min_capacity;
    rp->elems = xcalloc((size_t)rp->capacity, sizeof *rp->elems);
    rp->size = 0;
}

// Destroys a row in an adjacency list, freeing resources.
static void row_destroy(struct row *const rp)
{
    DESTROY(rp->elems);
    rp->capacity = rp->size = 0;
}

// Increase the capacity of this row. Implementation detail of row.
static void row_detail_grow(struct row *const rp)
{
    rp->capacity *= 2;
    rp->elems = xrealloc(rp->elems, (size_t)rp->capacity * sizeof *rp->elems);
}

// Append a new item to the end of this row.
static void row_push_back(struct row *const rp,
                          const int dest, const int weight)
{
    if (rp->size == rp->capacity) row_detail_grow(rp);

    struct out_edge *const ep = &rp->elems[rp->size++];
    ep->dest = dest;
    ep->weight = weight;
}

// Get a const pointer to the first element of a row.
static inline const struct out_edge *row_cbegin(const struct row *const rp)
{
    return rp->elems;
}

// Get a const pointer one past the last element of row.
static inline const struct out_edge *row_cend(const struct row *const rp)
{
    return rp->elems + rp->size;
}

// A weighted undirected graph, represented as an adjacency list.
struct graph {
    struct row *adj;
    int vertex_count;
};

// Create a weighted undirected graph with vertices 0, ..., vertex_count - 1.
// No vertices can be added or removed. The graph starts with no edges.
// To clean up, a graph_create call should be paired with a graph_destroy call.
static void graph_create(struct graph *const gp, const int vertex_count)
{
    assert(vertex_count >= 0);

    gp->adj = xcalloc((size_t)vertex_count, sizeof *gp->adj);
    for (int v = 0; v != vertex_count; ++v) row_create(&gp->adj[v]);
    gp->vertex_count = vertex_count;
}

// Destroy a graph, cleanup up resources.
static void graph_destroy(struct graph *const gp)
{
    while (gp->vertex_count != 0) row_destroy(&gp->adj[--gp->vertex_count]);
    DESTROY(gp->adj);
}

// Add a weighted undirected edge to a graph.
static void graph_add_edge(const struct graph *const gp,
                           const int u, const int v, const int weight)
{
    assert(0 <= u && u < gp->vertex_count);
    assert(0 <= v && v < gp->vertex_count);

    row_push_back(&gp->adj[u], v, weight);
    row_push_back(&gp->adj[v], u, weight);
}

// Run the major loop of Prim's algorithm. Implementation detail of graph.
static int graph_detail_prim_loop(const struct graph *restrict const gp,
                                  struct pq *restrict const pqp,
                                  bool *restrict const vis)
{
    int total_weight = 0;

    while (!pq_empty(pqp)) {
        const int src = pq_peek(pqp)->key;
        const int src_cost = pq_peek(pqp)->value;
        pq_pop(pqp);
        vis[src] = true;
        total_weight += src_cost;

        const struct out_edge *const ep_end = row_cend(&gp->adj[src]);
        for (const struct out_edge *ep = row_cbegin(&gp->adj[src]);
                ep != ep_end; ++ep) {
            if (!vis[ep->dest]) pq_push_or_decrease(pqp, ep->dest, ep->weight);
        }
    }

    return total_weight;
}

// Find the total weight of an MST by Prim's algorithm, traversing from start.
static int graph_mst_total_weight(const struct graph *const gp, const int start)
{
    assert(0 <= start && start < gp->vertex_count);

    struct pq pq = {0};
    pq_create(&pq, gp->vertex_count);
    bool *vis = xcalloc((size_t)gp->vertex_count, sizeof *vis);

    pq_push_or_decrease(&pq, start, 0);
    const int total_weight = graph_detail_prim_loop(gp, &pq, vis);

    DESTROY(vis);
    pq_destroy(&pq);

    return total_weight;
}

int main(void)
{
    int vertex_count = 0, edge_count = 0;
    scanf("%d%d", &vertex_count, &edge_count);

    struct graph graph = {0};
    graph_create(&graph, vertex_count + 1); // +1 for 1-based indexing.

    while (edge_count-- > 0) {
        int u = 0, v = 0, weight = 0;
        scanf("%d%d%d", &u, &v, &weight);
        graph_add_edge(&graph, u, v, weight);
    }

    int start = 0;
    scanf("%d", &start);
    printf("%d\n", graph_mst_total_weight(&graph, start));

    graph_destroy(&graph);
}
