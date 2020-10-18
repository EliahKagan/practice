#!/usr/bin/env perl

use strict;
use warnings;
use 5.022;

while (<<>>) {
    print "$1,$2\n" if m{<a\s(?:.*?\s)??href="(.+?)".*?>(.*?)</a>}msxi;
}

