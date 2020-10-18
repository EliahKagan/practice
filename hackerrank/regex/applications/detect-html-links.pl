#!/usr/bin/env perl

use strict;
use warnings;
use 5.022;
use English;

local $INPUT_RECORD_SEPARATOR = undef;
my $corpus = <<>>;
my @links = $corpus =~ m{<a\s(?:.*?\s)??href="(.+?)".*?>(.*?)</a>}msxig;

while (@links) {
    my $url = shift @links;
    my $text = shift @links;
    print "$url,$text\n";
}
