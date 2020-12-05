#!/bin/sh
perl -wnE 'chomp; y/FB/01/; y/LR/01/; say oct "0b$_"' "$@" | sort -n | less
