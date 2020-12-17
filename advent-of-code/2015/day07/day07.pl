#!/usr/bin/env perl
# Advent of Code 2015, day 7, both parts, with cycle detection
# Implemented using a single hash of code references acting as thunks.

use strict;
use warnings;
use 5.022;
use Carp qw(croak);
use Readonly;
use Data::Dumper;

Readonly my $DEBUG_EVALUATIONS => 0;
Readonly my $DEBUG_THUNKS => 0;
Readonly my $EVALUATE_ALL_THUNKS => 0;

Readonly my $MASK => 65_535;

Readonly my %UNARIES => (
    NOT => sub {
        my ($arg) = @_;
        return ~$arg & $MASK;
    },
);

Readonly my %BINARIES => (
    AND => sub {
        my ($arg1, $arg2) = (@_);
        return $arg1 & $arg2;
    },
    OR => sub {
        my ($arg1, $arg2) = (@_);
        return $arg1 | $arg2;
    },
    LSHIFT => sub {
        my ($arg1, $arg2) = (@_);
        return ($arg1 << $arg2) & $MASK;
    },
    RSHIFT => sub {
        my ($arg1, $arg2) = (@_);
        return $arg1 >> $arg2;
    },
);

my %variables;

my $defer = sub {
    my ($name, $implementation) = @_;

    $variables{$name} = sub {
        $variables{$name} = sub {
            croak qq{Cycle encountered while evaluating "$name"};
        };

        my $value = $implementation->();
        $variables{$name} = sub { $value };
        return $value;
    };

    return;
};

my $evaluate_variable = sub {
    my ($name) = @_;
    my $value = $variables{$name}->();
    if ($DEBUG_EVALUATIONS) { print "Evaluated $name. Got $value.\n" }
    return $value;
};

my $compile = sub {
    my ($expr) = @_;

    if ($expr =~ /^\d+$/msx) {
        $expr += 0;
        return sub { $expr };
    }

    return sub { $evaluate_variable->($expr) };
};

my $bind_simple = sub {
    my ($name, $expr) = @_;
    $defer->($name, $compile->($expr));
    return;
};

my $bind_unary = sub {
    my ($name, $unary, $expr) = @_;
    my $arg = $compile->($expr);
    $defer->($name, sub { $unary->($arg->()) });
    return;
};

my $bind_binary = sub {
    my ($name, $binary, $expr1, $expr2) = @_;
    my $arg1 = $compile->($expr1);
    my $arg2 = $compile->($expr2);
    $defer->($name, sub { $binary->($arg1->(), $arg2->()) });
    return;
};

while (my $line = <<>>) {
    $line =~ s/\s+$//msx;
    $line =~ s/^\s+//msx;
    next if $line eq q{};

    my ($rule, $name) = $line =~ /^(.*?)\s+->\s+(.*?)$/msx
        or croak qq{malformed binding "$line"};

    $name =~ /^[[:alpha:]]\w*$/msx or croak qq{bad variable name "$name"};

    if (my ($simple_expr) = $rule =~ /^(\S+)$/msx) {
        $bind_simple->($name, $simple_expr);
    } elsif (my ($unary_keyword, $unary_expr) =
                $rule =~ /^(\S+)\s+(\S+)$/msx) {
        my $unary_op = $UNARIES{$unary_keyword}
            or croak qq{unrecognized unary operator "$unary_keyword"};
        $bind_unary->($name, $unary_op, $unary_expr);
    } elsif (my ($binary_expr1, $binary_keyword, $binary_expr2) =
                $rule =~ /^(\S+)\s+(\S+)\s+(\S+)$/msx) {
        my $binary_op = $BINARIES{$binary_keyword}
            or croak qq{unrecognized binary operator "$binary_keyword"};
        $bind_binary->($name, $binary_op, $binary_expr1, $binary_expr2);
    } else {
        croak qq{malformed rule "$rule"};
    }
}

my %snapshot = %variables;

if ($EVALUATE_ALL_THUNKS) {
    for my $name (keys %variables) {
        my $value = $evaluate_variable->($name);
        print "$name: $value\n";
    }
}

my $old_a_value = $evaluate_variable->('a');
if ($DEBUG_THUNKS) { print Dumper(\%variables) };
print "Before rewire: $old_a_value\n";

%variables = %snapshot;

$bind_simple->('b', $old_a_value);
my $new_a_value = $evaluate_variable->('a');
print "After rewire: $new_a_value\n";
