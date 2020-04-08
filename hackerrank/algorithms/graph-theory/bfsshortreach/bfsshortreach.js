#!/usr/bin/env node

// https://www.hackerrank.com/challenges/bfsshortreach
// In JavaScript. (Using breadth-first search.)

'use strict';

// Creates an array of the specified number of empty arrays.
function make_arrays(outer_length) {
    return new Array(outer_length).fill(undefined).map(_ => []);
}

function ensure_positive(description, value) {
    if (!(value > 0)) { // Catch wrong type or value.
        throw new Error(`${description} must be positive`);
    }
}

// Reads a graph as an adjacency list.
function read_graph(reader) {
    const [vertex_count, edge_count] = reader.read_record();
    ensure_positive('vertex count', vertex_count);
    ensure_positive('edge count', edge_count);

    function check_vertex(vertex) {
        if (!(0 < vertex && vertex <= vertex_count)) { // 1-based indexing
            throw new Error('edge vertex not in graph (out of range)');
        }
    }

    const adj = make_arrays(vertex_count + 1); // +1 for 1-based indexing

    for (let more_edges = edge_count; more_edges > 0; --more_edges) {
        const [u, v] = reader.read_record();
        check_vertex(u);
        check_vertex(v);

        adj[u].push(v);
        adj[v].push(u);
    }

    return adj;
}

// Computes path lengths, with edge weights of 1, from start to each vertex.
function bfs(adj, start) {
    const costs = new Array(adj.length).fill(undefined);
    costs[start] = 0;
    let parents = [start];

    for (let cost = 1; parents.length !== 0; ++cost) {
        const children = [];

        for (const src of parents) {
            for (const dest of adj[src]) {
                if (costs[dest] !== undefined) continue;
                costs[dest] = cost;
                children.push(dest);
            }
        }

        parents = children;
    }

    return costs;
}

const NOT_REACHED = -1; // Displayed cost to reach an unreachable vertex.
const EDGE_WEIGHT = 6; // Every edge actually has this weight rather than 1.

// Reports the cost of all minimum-cost paths from start, except to itself.
function report(costs, start) {
    console.log(costs.filter((_, index) => index !== 0 && index !== start)
                     .map(cost => cost === undefined ? NOT_REACHED
                                                     : cost * EDGE_WEIGHT)
                     .join(' '));
}

function main(reader) {
    for (let q = reader.read_value(); q > 0; --q) {
        const adj = read_graph(reader);

        const start = reader.read_value();
        if (!(0 < start && start < adj.length)) {
            throw new Error('start vertex not in graph (out of range)');
        }

        report(bfs(adj, start), start);
    }
}

(function () {
    const reads = [];
    process.stdin.resume();
    process.stdin.setEncoding('utf-8');
    process.stdin.on('data', data => reads.push(data));
    process.stdin.on('end', () => {
        const lines = reads.join('').split('\n');
        let index = 0;
        main(Object.freeze({
            read_value: function () {
                return parseInt(this._read_line());
            },
            read_record: function () {
                return this._read_line()
                           .split(/\s+/u)
                           .filter(tok => tok)
                           .map(tok => parseInt(tok));
            },
            _read_line: function () {
                return lines[index++];
            }
        }));
    });
})();
