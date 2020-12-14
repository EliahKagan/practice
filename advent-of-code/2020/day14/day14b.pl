#!/usr/bin/env perl
# Advent of Code 2020, day 14, part B

use strict;
use warnings;
use 5.026;
#use bigint;
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

my %mem;

my $multicast_mask = 0;

my sub multicast($address, $value, $from_bit) {
    while (($from_bit & $MAX) != 0 && ($from_bit & $multicast_mask) == 0) {
        $from_bit <<= 1;
    }

    if (($from_bit & $MAX) == 0) {
        $mem{$address} = $value;
        return;
    }

    if ($DEBUG) {
        printf {*STDERR} "multicast(%b, %b, %b)\n",
                         $address, $value, $from_bit;
    }

    __SUB__->($address, $value, $from_bit << 1);
    __SUB__->($address ^ $from_bit, $value, $from_bit << 1);
    return;
}

my $or_mask = 0;

while (my $line = <<>>) {
    $line =~ s/\s+$//msx;
    $line =~ s/^\s+//msx;
    if (length $line == 0) { next }

    if (my ($mask) = $line =~ /^mask\s+=\s+([01X]{$WIDTH})$/msx) {
        $multicast_mask = from_binary($mask =~ y/1X/01/r);
        $or_mask = from_binary($mask =~ y/X/0/r);
    } elsif (my ($address, $value) =
                $line =~ /^mem\[(\d+)\]\s+=\s+(\d+)$/msx) {
        if ($address > $MAX) { croak "address $address is too big\n" }
        if ($value > $MAX) { croak "value $value is too big\n" }
        multicast($address | $or_mask, $value, 1);
    } else {
        croak "malformed line: $line\n";
    }
}

say sum0(values %mem);
