#!/usr/bin/env perl

use strict;
use warnings;
use 5.022;
use English;

sub strip_tags {
    my ($text) = @_;
    $text =~ s/<.*?>//msxg;
    return $text;
}

sub consolidate_whitespace {
    my ($text) = @_;
    return join q{ }, $text =~ /\S+/msxg;
}

local $INPUT_RECORD_SEPARATOR = undef;
my $corpus = <<>>;
my @links = $corpus =~ m{<a\s(?:.*?\s)??href="(.+?)".*?>(.*?)</a>}msxig;

while (@links) {
    my $url = shift @links;
    my $raw_text = shift @links;
    my $text = consolidate_whitespace(strip_tags($raw_text));
    print "$url,$text\n";
}
