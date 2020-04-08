#!/usr/bin/env perl

# https://www.hackerrank.com/challenges/bfsshortreach
# In Perl. (Using breadth-first search.)

use strict;
use warnings;
use v5.26;
use experimental qw(signatures);

# Given as the minimum cost to reach an unreachable vertex. Conceptually, this
# value represents positive infinity.
use constant NOT_REACHED => -1;

# Edges each have this weight, rather than 1.
use constant EDGE_WEIGHT => 6;

# Reads a graph as an adjacency list.
sub read_graph() {
    my ($vertex_count, $edge_count) = split /\s+/msx, <<>>;
    $vertex_count >= 0 or die q{can't have negatively many vertices};
    $edge_count >= 0 or die q{can't have negatively many edges};
    my sub in_range($vertex) { 0 < $vertex && $vertex <= $vertex_count }

    my @adj = map { [] } (0..$vertex_count); # extra entry for 1-based indexing

    for (1..$edge_count) {
        my ($u, $v) = split /\s+/msx, <<>>;
        in_range($u) && in_range($v) or die 'edge vertex not in range';
        push @{$adj[$u]}, $v;
        push @{$adj[$v]}, $u;
    }

    return \@adj;
}

# Computes path lengths, with edge weights of 1, from src to each vertex.
sub bfs($adj, $src) {
    my @costs = (undef) x scalar @{$adj};
    my $cost = $costs[$src] = 0;
    my @queue = ($src);

    while (@queue) {
        ++$cost;

        for (0..$#queue) {
            $src = shift @queue;

            for my $dest (@{$adj->[$src]}) {
                next if defined $costs[$dest];
                $costs[$dest] = $cost;
                push @queue, $dest;
            }
        }
    }

    return \@costs;
}

# Reports actual costs of all minimum-cost paths from start, except to itself.
sub report($costs, $start) {
    my @others = (@{$costs}[1..($start - 1)],
                  @{$costs}[($start + 1)..$#{$costs}]);

    say join q{ }, map { defined $_ ? $_ * EDGE_WEIGHT : NOT_REACHED } @others;

    return;
}

my $q = <<>>;

for (1..$q) {
    my $adj = read_graph();

    my $start = <<>>;
    0 < $start && $start <= $#{$adj} or die 'start vertex not in range';

    report(bfs($adj, $start), $start);
}
