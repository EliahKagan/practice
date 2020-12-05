#!/usr/bin/env perl
# Advent of Code 2020, day 5, part B

use strict;
use warnings;
use feature qw(say);
use Carp qw(carp);
use List::Util qw(first);

sub decode {
    my $value = shift;
    chomp $value;
    $value =~ y/FB/01/;
    $value =~ y/LR/01/;
    return oct "0b$value";
}

my @seats = sort { $a <=> $b } map { decode $_ } <<>>;
my $index = first { $seats[$_] - 1 != $seats[$_ - 1] } (1..$#seats);
$seats[$index] - 1 == $seats[$index - 1] + 1 or carp "warning: wrong size gap\n";
say $seats[$index] - 1;
