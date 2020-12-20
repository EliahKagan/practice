#!/usr/bin/env perl
# Advent of Code 2020, day 19, part B

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

sub fix_rule_for_part_b($rule) {
    return '8: 42 | 42 8' if $rule eq '8: 42';
    return '11: 42 31 | 42 11 31' if $rule eq '11: 42 31';
    return $rule;
}

my $show_pattern = 0;
my $show_matches = 0;

GetOptions('pattern|p' => \$show_pattern, 'grep|g' => \$show_matches)
    or exit 1;

my %rules;

my sub make_nonterminal_rule($id, @template) {
    return sub {
        $rules{$id} = sub { croak "cyclic dependency for rule $id" };

        my $direct_recursive = 0;

        my @alternatives = map {
            join q{}, map { # FIXME: This is confusing. Refactor.
                if ($_ == $id) {
                    $direct_recursive = 1;
                    '(?-1)';
                } else {
                    $rules{$_}->();
                }
            } @{$_}
        } @template;

        my $unparenthesized = join q{|}, @alternatives;
        my $pattern;

        if ($direct_recursive) {
            $pattern = "($unparenthesized)";
        } elsif (scalar @alternatives > 1) {
            $pattern = "(?:$unparenthesized)";
        } else {
            $pattern = $unparenthesized;
        }

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
    my ($id_digits, $expr) = split /:\s+/msx, fix_rule_for_part_b($_);
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
