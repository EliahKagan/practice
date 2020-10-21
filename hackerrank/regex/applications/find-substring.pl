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

my $text = join q{ }, read_trimmed_lines();
my @patterns = read_trimmed_lines();
my $match_count = 0;

for my $pattern (@patterns) {
    my @matches = $text =~ /\w(?=\Q$pattern\E\w)/msxg;
    $match_count += scalar @matches;
}

print "$match_count\n";
