#!/usr/bin/env perl

use strict;
use warnings;
use 5.022;
use English;

sub sort_unique {
    my @words = (@_);

    my %unique_words;
    for my $word (@words) {
        $unique_words{$word} = 1;
    }

    my @sorted_words = sort(keys %unique_words);
    return @sorted_words;
}

local $INPUT_RECORD_SEPARATOR = undef;
my $corpus = <<>>;
my @tags = $corpus =~ /<\s*(\w+)/msxg;
say join ';', sort_unique(@tags);
