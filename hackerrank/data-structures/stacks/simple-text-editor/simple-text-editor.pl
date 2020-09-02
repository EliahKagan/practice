#!/usr/bin/env perl

# HackerRank - Simple Text Editor
# https://www.hackerrank.com/challenges/simple-text-editor
# with an undo stack of inverse actions

use strict;
use warnings;
use feature qw(say);
use experimental qw(signatures);

package Editor {
    sub new($class) {
        my $self = {buffer => q{}, undos => []};
        return bless $self, $class;
    }

    sub append_text($self, $text) {
        my $count = length $text;
        $self->{buffer} .= $text;
        push @{$self->{undos}}, sub { substr($self->{buffer}, -$count) = q{} };
        return;
    }

    sub shrink_by($self, $count) {
        my $text = substr $self->{buffer}, -$count, $count, q{};
        push @{$self->{undos}}, sub { $self->{buffer} .= $text };
        return;
    }

    sub print_character($self, $index) {
        say substr $self->{buffer}, $index - 1, 1;
        return;
    }

    sub undo($self) {
        pop(@{$self->{undos}})->();
        return;
    }
}

sub run() {
    my $editor = Editor->new();

    my $query_count = <>;

    for (1..$query_count) {
        my @tokens = grep { $_ } split /\s+/msx, <>;
        my $opcode = $tokens[0];

        if ($opcode == 1) {
            $editor->append_text($tokens[1]);
        } elsif ($opcode == 2) {
            $editor->shrink_by($tokens[1]);
        } elsif ($opcode == 3) {
            $editor->print_character($tokens[1]);
        } elsif ($opcode == 4) {
            $editor->undo();
        }
    }

    return;
}

if (!caller) { run() }
