#!/usr/bin/env perl
# Jim and his LAN Party
# https://www.hackerrank.com/challenges/jim-and-his-lan-party

use strict;
use warnings;
use 5.020;
use experimental qw(signatures);
use feature qw(say);

# A network of elements representing users or machines, each of whom is a
# member of exactly one group, which can meet/play when all members are
# connected in a component (possibly shared with members of other groups).
package Network {
    use constant NOT_CONNECTED => -1;

    # Creates a new network with groups in [0, $group_count) and elements in
    # [0, $#element_groups]. Element $i is a member of $element_groups[$i].
    sub new($class, $group_count, @element_groups) {
        my $total_size = scalar @element_groups;

        my $self = {
            time => 0,
            group_sizes => [(0) x $group_count],
            group_completion_times => [(NOT_CONNECTED) x $group_count],
            elem_contributions => [(undef) x $total_size],
            elem_parents => [0..($total_size - 1)],
            elem_ranks => [(0) x $total_size],
        };

        for my $group (@element_groups) {
            ++$self->{group_sizes}[$group];
        }

        while (my ($group, $size) = each @{$self->{group_sizes}}) {
            if ($size < 2) {
                $self->{group_completion_times}[$group] = $self->{time};
            }
        }

        while (my ($elem, $group) = each @element_groups) {
            if ($self->{group_completion_times}[$group] == NOT_CONNECTED) {
                $self->{elem_contributions}[$elem] = {$group => 1};
            }
        }

        return bless $self, $class;
    }

    # Retrieves the times at which each group finished becoming connected.
    # For groups that were never connected, NOT_CONNECTED is returned.
    sub completion_times($self) {
        return @{$self->{group_completion_times}};
    }

    # Adds an edge/wire connecting $elem1 and $elem2.
    sub union($self, $elem1, $elem2) {
        ++$self->{time};

        # Find the ancestors and stop if they are already the same.
        $elem1 = $self->_find_set($elem1);
        $elem2 = $self->_find_set($elem2);
        return if $elem1 == $elem2;

        # Union by rank, merging contributions.
        if ($self->{elem_ranks}[$elem1] < $self->{elem_ranks}[$elem2]) {
            $self->_join($elem2, $elem1);
        } else {
            if ($self->{elem_ranks}[$elem1] == $self->{elem_ranks}[$elem2]) {
                ++$self->{elem_ranks}[$elem1];
            }
            $self->_join($elem1, $elem2);
        }

        return;
    }

    # Union-find "findset" operation with full path compression.
    sub _find_set($self, $elem) {
        # Find the ancestor.
        my $leader = $elem;
        while ($leader != $self->{elem_parents}[$leader]) {
            $leader = $self->{elem_parents}[$leader];
        }

        # Compress the path.
        while ($elem != $leader) {
            my $parent = $self->{elem_parents}[$elem];
            $self->{elem_parents}[$elem] = $leader;
            $elem = $parent;
        }

        return $leader;
    }

    # Makes $child a child of $parent and merges contributions into $parent.
    sub _join($self, $parent, $child) {
        $self->{elem_parents}[$child] = $parent;

        $self->{elem_contributions}[$parent] =
            $self->_merge_contributions($self->{elem_contributions}[$parent],
                                        $self->{elem_contributions}[$child]);

        undef $self->{elem_contributions}[$child];

        return;
    }

    # Merges contributions into whichever contribution hash started out larger,
    # recording and removing items that become complete as a result.
    # Returns the resulting hash, or undef if that hash is ultimately empty.
    sub _merge_contributions($self, $contrib1, $contrib2) {
        # If either or both are undefined, there is nothing to do.
        if (!defined $contrib1 || !defined $contrib2) {
            return $contrib1 // $contrib2;
        }

        # Merge the bigger one (so we loop over the smaller).
        return scalar %{$contrib1} < scalar %{$contrib2}
                ? $self->_do_merge_contributions($contrib2, $contrib1)
                : $self->_do_merge_contributions($contrib1, $contrib2);
    }

    # Merges the source into the sink. Helper for _merge_contributions.
    sub _do_merge_contributions($self, $sink, $source) {
        while (my ($group, $source_count) = each %{$source}) {
            my $sum = ($sink->{$group} // 0) + $source_count;

            if ($sum < $self->{group_sizes}[$group]) {
                $sink->{$group} = $sum;
            } else {
                delete $sink->{$group};
                $self->{group_completion_times}[$group] = $self->{time};
            }
        }

        return scalar %{$sink} == 0 ? undef : $sink;
    }
}

# Reads a line as a list of values.
sub read_record() {
    return <<>> =~ /\S+/msxg;
}

# Read the problem parameters. ($_player_count is currently not checked.)
my ($_player_count, $game_count, $wire_count) = read_record();

# Make the LAN. The extra 0 element and 0 group facilitate 1-based indexing.
my $network = Network->new($game_count + 1, 0, read_record());

# Read and apply app the connections.
for (1..$wire_count) {
    $network->union(read_record());
}

# Skip the extra 0 group and print other groups' completion times.
my @times = $network->completion_times;
shift @times;
for my $time (@times) { say $time }
