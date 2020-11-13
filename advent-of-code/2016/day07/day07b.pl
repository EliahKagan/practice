#!/usr/bin/env perl

use strict;
use warnings;
use 5.022;

my $count = 0;

while (<<>>) {
    ++$count if m{
        ^(?:\w*\[\w*\])*  # up to the start of ANY outside region
        \w*               # leading text in that outside region
        (\w)(?!\1)(\w)\1  # ABA sequence
        \w*\[             # up to the NEXT inside region
        (?:\w*\]\w*\[)*   # maybe skip to a later inside region
        \w*               # leading text in that inside region
        \2\1\2            # BAB sequence

      | ^\w*\[            # up to the start of the FIRST inside region
        (?:\w*\]\w*\[)*   # maybe skip to a later inside region
        \w*               # leading text in that inside region
        (\w)(?!\3)(\w)\3  # ABA sequence
        \w*\]             # up to the NEXT outside region
        (?:\w*\[\w*\])*   # maybe skip to a later outside region
        \w*               # leading text in that outside region
        \4\3\4            # BAB sequence
      }msx;
}

print "$count\n";
