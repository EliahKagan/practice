#!/usr/bin/env perl
# Advent of Code 2020, day 14, part A

use strict;
use warnings;
use 5.022;
use bigint;
use experimental qw(signatures);
use Carp;
use List::Util qw(sum0);
use Readonly;

Readonly my $DEBUG => 0;
Readonly my $WIDTH => 36;
Readonly my $MAX => 2**$WIDTH - 1;

sub from_binary($binary) {
    return oct "0b$binary";
}

my $and_mask = $MAX;
my $or_mask = 0;
my %mem;

while (my $line = <<>>) {
    $line =~ s/\s+$//msx;
    $line =~ s/^\s+//msx;
    if (length $line == 0) { next }

    if (my ($mask) = $line =~ /^mask\s+=\s+([01X]{$WIDTH})$/msx) {
        $and_mask = from_binary($mask =~ s/[^0]/1/msxgr);
        $or_mask = from_binary($mask =~ s/[^1]/0/msxgr);
    } elsif (my ($index, $value) = $line =~ /^mem\[(\d+)\]\s+=\s+(\d+)$/msx) {
        if ($index > $MAX) { croak "index $index is too big\n" }
        if ($value > $MAX) { croak "value $value is too big\n" }
        $mem{$index} = ($value & $and_mask) | $or_mask;
        if ($DEBUG) { say "mem[$index] = $value" }
    } else {
        croak "malformed line: $line\n";
    }
}

say sum0(values %mem);
