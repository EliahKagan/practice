#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 7, part A

$VERBOSE = true

require 'set'

# A leaf node in a simulated directory tree representing a regular file.
class FileNode
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

# A node in a simulated directory tree representing a directory.
class DirNode
  attr_reader :name

  def initialize(name)
    @name = name
    @entries = {}
  end

  def make_file(name, size)
    check_name(name)
    @entries[name] = FileNode.new(name, size)
    nil
  end

  def make_dir(name)
    check_name(name)
    @entries[name] = DirNode.new(name)
  end

  def each_entry(&)  # FIXME: Decide whether to keep this method.
    @entries.each(&)
  end

  def total_dir_sizes
  end

  protected

  def do_total_dir_sizes(out)
    #out[self] =
  end

  private

  def check_name(name)
    raise "node already exists: #{name}" if @entries.key?(name)
  end
end

def run
  # FIXME: Implement this.
end

run if $PROGRAM_NAME == __FILE__
