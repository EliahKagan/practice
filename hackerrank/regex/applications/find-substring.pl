#!/usr/bin/env perl
# HackerRank - Find A Sub-Word
# https://www.hackerrank.com/challenges/find-substring

use strict;
use warnings;
use 5.022;

sub read_trimmed_lines {
    my $count = <<>>;
    my @lines;

    for (1..$count) {
        my $line = <<>>;
        $line =~ s/\A\s+//msx;
        $line =~ s/\s+\z//msx;
        push @lines, $line;
    }

    return @lines;
}

sub count_proper_subword_matches {
    my ($text, $pattern) = @_;

    if ($pattern =~ /\A\w+\z/msx) {
        my @matches = $text =~ /\w(?=\Q$pattern\E\w)/msxg;
        return scalar @matches;
    }

    return 0;
}

my $text = join q{ }, read_trimmed_lines();
my @patterns = read_trimmed_lines();

for my $pattern (@patterns) {
    say count_proper_subword_matches($text, $pattern);
}
