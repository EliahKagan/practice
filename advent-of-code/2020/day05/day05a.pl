#!/usr/bin/env perl
# Advent of Code 2020, day 5, part A

use strict;
use warnings;
use feature qw(say);
use List::Util qw(max);

sub decode {
    my $value = shift;
    chomp $value;
    $value =~ y/FB/01/;
    $value =~ y/LR/01/;
    return oct "0b$value";
}

say max(map { decode $_ } <<>>);
