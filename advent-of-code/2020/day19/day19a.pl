#!/usr/bin/env perl
# Advent of Code 2020, day 19, part A

use strict;
use warnings;
use 5.026;
use feature qw(say);
use experimental qw(signatures);
use Carp qw(croak);
use Getopt::Long qw(:config bundling);

sub each_line_in_stanza :prototype(&) ($code) {
    while (<<>>) {
        s/\s+$//msx;
        s/^\s+//msx;
        last if length == 0;
        $code->();
    }
    return;
}

my $show_pattern = 0;
my $show_matches = 0;

GetOptions('pattern|p' => \$show_pattern, 'grep|g' => \$show_matches)
    or exit 1;

my %rules;

my sub make_nonterminal_rule($id, @template) {
    return sub {
        $rules{$id} = sub { croak "cyclic dependency for rule $id" };

        my @alternatives = map {
            join q{}, map { $rules{$_}->() } @{$_}
        } @template;

        my $unparenthesized = join q{|}, @alternatives;

        my $pattern = (scalar @alternatives == 1 ? $unparenthesized
                                                 : "(?:$unparenthesized)");

        $rules{$id} = sub { $pattern };
        return $pattern;
    };
}

my sub add_rule($id, $expr) {
    if (my ($literal) = $expr =~ /^"([^"]+)"$/msx) {
        my $escaped = quotemeta $literal;
        $rules{$id} = sub { $escaped };
    } else {
        # Split alternation into a list of branches.
        my @branches = split /\s+[|]\s+/msx, $expr;

        # Map each branch to the row of ids of subpatterns for concatenation.
        my @template = map { [map { $_ + 0 } split /\s+/msx] } @branches;

        $rules{$id} = make_nonterminal_rule($id, @template);
    }
    return;
}

each_line_in_stanza {
    my ($id_digits, $expr) = split /:\s+/msx;
    add_rule($id_digits + 0, $expr);
};

my $pattern = $rules{0}->();
if ($show_pattern) { print "$pattern\n\n" }
my $line_regex = qr/^$pattern$/msx;

my $count = 0;
each_line_in_stanza {
    if ($_ =~ $line_regex) {
        ++$count;
        if ($show_matches) { say };
    }
};

if ($show_matches) { print "\n" }
say $count;
