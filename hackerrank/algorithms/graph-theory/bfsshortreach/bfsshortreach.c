#include <assert.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DESTROY(p) do { free(p); (p) = NULL; } while (false)

// FIXME: After preliminary testing, change initial nonzero capacities to 8.
enum data_structure_constants {
    k_vec_initial_nonzero_capacity = 1,
    k_queue_initial_nonzero_capacity = 1,
};

enum graph_constants {
    k_infinity = INT_MAX,
    k_universal_edge_weight = 6,
    k_unreachable_display_value = -1,
};

static void ensure(bool condition)
{
    if (!condition) abort();
}

static inline size_t min(const size_t x, const size_t y)
{
    return y < x ? y : x;
}

static void *xcalloc(const size_t num, const size_t size)
{
    assert(num != 0u);
    assert(size != 0u);

    void *const p = calloc(num, size);
    ensure(p);
    return p;
}

static void *xrealloc(void *p, const size_t size)
{
    assert(size != 0u);

    p = realloc(p, size);
    ensure(p);
    return p;
}

typedef int Vertex;

struct vec {
    Vertex *buffer;
    size_t capacity;
    size_t size;
};

static void vec_destroy(struct vec *const vecp)
{
    assert(vecp);

    DESTROY(vecp->buffer);
    vecp->capacity = vecp->size = 0u;
}

static size_t vec_detail_next_capacity(const struct vec *const vecp)
{
    assert(vecp);

    if (vecp->capacity == 0u) {
        assert(!vecp->buffer);
        return k_vec_initial_nonzero_capacity;
    } else {
        assert(vecp->buffer);
        return vecp->capacity * 2u;
    }
}

static void vec_detail_grow(struct vec *const vecp)
{
    assert(vecp);

    vecp->capacity = vec_detail_next_capacity(vecp);

    vecp->buffer = xrealloc(vecp->buffer,
                            vecp->capacity * sizeof *vecp->buffer);
}

static void vec_push(struct vec *const vecp, const Vertex value)
{
    assert(vecp);

    assert(vecp->size <= vecp->capacity);
    if (vecp->size == vecp->capacity) vec_detail_grow(vecp);

    vecp->buffer[vecp->size++] = value;
}

static inline Vertex *vec_begin(const struct vec *const vecp)
{
    assert(vecp);
    return vecp->buffer;
}

static inline Vertex *vec_end(const struct vec *const vecp)
{
    assert(vecp);
    return vecp->buffer ? vecp->buffer + vecp->size : NULL;
}

static inline const Vertex *vec_cbegin(const struct vec *const vecp)
{
    return vec_begin(vecp);
}

static inline const Vertex *vec_cend(const struct vec *const vecp)
{
    return vec_end(vecp);
}

struct queue {
    Vertex *buffer;
    size_t capacity;
    size_t front;
    size_t size;
};

static struct queue queue_create(void)
{
    return (struct queue) { NULL, 0u, 0u, 0u };
}

static void queue_destroy(struct queue *const queuep)
{
    assert(queuep);

    DESTROY(queuep->buffer);
    queuep->capacity = queuep->front = queuep->size = 0u;
}

static inline size_t queue_size(const struct queue *const queuep)
{
    assert(queuep);
    return queuep->size;
}

static inline bool queue_empty(const struct queue *const queuep)
{
    return queue_size(queuep) == 0u;
}

static size_t queue_detail_next_capacity(const struct queue *const queuep)
{
    assert(queuep);

    if (queuep->capacity == 0u) {
        assert(!queuep->buffer);
        return k_queue_initial_nonzero_capacity;
    } else {
        assert(queuep->buffer);
        return queuep->capacity * 2u;
    }
}

static void queue_detail_grow(struct queue *const queuep)
{
    assert(queuep);

    const size_t new_capacity = queue_detail_next_capacity(queuep);

    Vertex *restrict const new_buffer = xcalloc(new_capacity,
                                                sizeof *new_buffer);

    if (queuep->buffer) {
        assert(queuep->front < queuep->capacity);

        const size_t prewrap = min(queuep->size,
                                   queuep->capacity - queuep->front);

        memcpy(new_buffer,
               queuep->buffer + queuep->front,
               prewrap * sizeof *queuep->buffer);

        memcpy(new_buffer + prewrap,
               queuep->buffer,
               (queuep->size - prewrap) * sizeof *queuep->buffer);

        DESTROY(queuep->buffer);
    }

    queuep->buffer = new_buffer;
    queuep->capacity = new_capacity;
    queuep->front = 0u;
}

static void queue_enqueue(struct queue *const queuep, const Vertex value)
{
    assert(queuep);

    assert(queuep->size <= queuep->capacity);
    if (queuep->size == queuep->capacity) queue_detail_grow(queuep);

    assert(queuep->front < queuep->capacity);
    const size_t back = (queuep->front + queuep->size) % queuep->capacity;
    queuep->buffer[back] = value;
    ++queuep->size;
}

static Vertex queue_dequeue(struct queue *const queuep)
{
    assert(queuep);
    assert(!queue_empty(queuep));

    assert(queuep->buffer);
    assert(queuep->front < queuep->capacity);
    const Vertex value = queuep->buffer[queuep->front];

    queuep->buffer[queuep->front] = 0; // For easier debugging.
    queuep->front = (queuep->front + 1u) % queuep->capacity;
    --queuep->size;

    return value;
}

#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpadded"
#endif
struct graph {
    struct vec *adj;
    int order;
};
#ifdef __GNUC__
#pragma GCC diagnostic pop
#endif

static struct graph graph_create(const int order)
{
    assert(order >= 0);

    struct graph graph = { NULL, 0 };

    if (order != 0) {
        graph.adj = xcalloc((size_t)order, sizeof *graph.adj);
        graph.order = order;
    }

    return graph;
}

static void graph_destroy(struct graph *const graphp)
{
    assert(graphp);

    for (Vertex i = 0; i < graphp->order; ++i) vec_destroy(&graphp->adj[i]);
    free(graphp->adj);
    graphp->adj = NULL;

    graphp->order = 0;
}

static inline int graph_order(const struct graph *const graphp)
{
    assert(graphp);
    return graphp->order;
}

static inline bool graph_has_vertex(const struct graph *const graphp,
                                    const Vertex vertex)
{
    assert(graphp);
    return 0 <= vertex && vertex < graphp->order;
}

static void graph_add_edge(const struct graph *const graphp,
                           const Vertex u, const Vertex v)
{
    assert(graphp);
    assert(graph_has_vertex(graphp, u));
    assert(graph_has_vertex(graphp, v));

    vec_push(&graphp->adj[u], v);
    vec_push(&graphp->adj[v], u);
}

static inline const Vertex
*graph_neighbors_begin(const struct graph *const graphp, const Vertex src)
{
    assert(graphp);
    assert(graph_has_vertex(graphp, src));

    return vec_cbegin(&graphp->adj[src]);
}

static inline const Vertex
*graph_neighbors_end(const struct graph *const graphp, const Vertex src)
{
    assert(graphp);
    assert(graph_has_vertex(graphp, src));

    return vec_cend(&graphp->adj[src]);
}

static inline void read_edge(const struct graph *const graphp)
{
    assert(graphp);

    Vertex u = 0;
    Vertex v = 0;

    ensure(scanf("%d%d", &u, &v) == 2);

    // Don't allow vertex 0.
    ensure(0 < u && u < graph_order(graphp));
    ensure(0 < v && v < graph_order(graphp));

    graph_add_edge(graphp, u, v);
}

static struct graph read_graph(void)
{
    int order = 0;
    int size = 0;
    ensure(scanf("%d%d", &order, &size) == 2);
    ensure(order > 0);
    ensure(size > 0);

    // Allocate an extra unused vertex (0) to facilitate 1-based indexing.
    const struct graph graph = graph_create(order + 1);
    while (size-- > 0) read_edge(&graph);
    return graph;
}

static int *infinite_costs(const int order)
{
    assert(order > 0);

    int *const costs = xcalloc((size_t)order, sizeof *costs);
    for (Vertex i = 0; i < order; ++i) costs[i] = k_infinity;
    return costs;
}

static void run_bfs(const struct graph *restrict const graphp,
                    int *restrict const costs,
                    bool *restrict const vis,
                    struct queue *restrict const fringep)
{
    assert(graphp);
    assert(costs);
    assert(vis);
    assert(fringep);

    for (int depth = 1; !queue_empty(fringep); ++depth) {
        fprintf(stderr, "DEBUG: depth=%d\n", depth); // FIXME: remove

        for (size_t breadth = queue_size(fringep); breadth != 0u; --breadth) {
            const Vertex src = queue_dequeue(fringep);
            fprintf(stderr, "DEBUG: breadth=%zu src=%d\n", breadth, src); // FIXME: remove
            const Vertex *const row_begin = graph_neighbors_begin(graphp, src);
            const Vertex *const row_end = graph_neighbors_end(graphp, src);

            for (const Vertex *destp = row_begin; destp != row_end; ++destp) {
                if (vis[*destp]) continue;

                fprintf(stderr, "DEBUG: dest=%d\n", *destp); // FIXME: remove
                vis[*destp] = true;
                costs[*destp] = depth;
                queue_enqueue(fringep, *destp);
            }
        }
    }
}

static int *bfs(const struct graph *const graphp, const Vertex start)
{
    assert(graphp);
    assert(graph_has_vertex(graphp, start));

    int *const costs = infinite_costs(graph_order(graphp));
    bool *vis = xcalloc((size_t)graph_order(graphp), sizeof *vis);
    struct queue fringe = queue_create();

    vis[start] = true;
    queue_enqueue(&fringe, start);
    run_bfs(graphp, costs, vis, &fringe);

    queue_destroy(&fringe);
    DESTROY(vis);
    return costs;
}

static void
print_scaled_costs(const int *const costs, const int order, const Vertex start)
{
    assert(costs);
    assert(0 < start && start < order); // Don't allow vertex 0.

    const char *sep = "";

    for (Vertex vertex = 1; vertex < order; ++vertex) {
        if (vertex == start) continue;

        const int display = (costs[vertex] == k_infinity
                                ? k_unreachable_display_value
                                : costs[vertex] * k_universal_edge_weight);

        printf("%s%d", sep, display);

        sep = " ";
    }

    putchar('\n');
}

static void run_query(void)
{
    struct graph graph = read_graph();

    Vertex start = 0;
    ensure(scanf("%d", &start) == 1);
    ensure(0 < start && start < graph_order(&graph)); // Don't allow vertex 0.

    int *costs = bfs(&graph, start);
    print_scaled_costs(costs, graph_order(&graph), start);

    DESTROY(costs);
    graph_destroy(&graph);
}

int main(void)
{
    int query_count = 0;
    ensure(scanf("%d", &query_count) == 1);
    ensure(query_count > 0);

    while (query_count-- > 0) run_query();
}
