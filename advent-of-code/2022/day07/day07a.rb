#!/usr/bin/env ruby
# frozen_string_literal: true

# Advent of Code 2022, day 7, part A

$VERBOSE = true

require 'optparse'

DEFAULT_CUTOFF = 100_000

# A leaf node in a simulated directory tree representing a regular file.
class FileNode
  attr_reader :parent, :name, :path, :size

  def initialize(parent, name, size)
    # FIXME: Extract shared initialization code to a module.
    raise %(file name can't contain "/") if name.include?('/')

    @parent = parent
    @name = name
    @path = "#{parent&.path}/#{name}"
    @size = size
  end
end

# A node in a simulated directory tree representing a directory.
class DirNode
  def self.new_root
    new(nil, '')
  end

  attr_reader :parent, :name, :path

  def initialize(parent, name)
    # FIXME: Extract shared initialization code to a module.
    raise %(directory name can't contain "/") if name.include?('/')

    @parent = parent
    @name = name
    @path = "#{parent&.path}/#{name}"
    @files = {}
    @dirs = {}
  end

  def get_file(name)
    @files.fetch(name)
  end

  def get_dir(name)
    @dirs.fetch(name)
  end

  def make_file(name:, size:)
    check_collision(name)
    @files[name] = FileNode.new(self, name, size)
    nil
  end

  def make_dir(name)
    check_collision(name)
    @dirs[name] = DirNode.new(self, name)
    nil
  end

  # Recurses directories here and below, yielding each with its total size.
  # Returns the total size of *this* directory.
  def total_sizes(&)
    size = @files.sum(&:size) + @dirs.each_value { |dir| dir.total_sizes(&) }
    yield self, size
    size
  end

  private

  def check_collision(name)
    raise "node already exists (as file): #{name}" if @files.key?(name)
    raise "node already exists (as directory): #{name}" if @dirs.key?(name)
  end
end

def resolve(node, target)
  case target
  when '/'
    parent = node.parent while node.parent
    parent
  when '..'
    # "cd .." from the root would stay here, but that may be unintended.
    raise 'ambiguous "cd .." from the root directory' unless node.parent

    node.parent
  else
    node.get_dir(target)
  end
end

def build_tree(lines)
  node = root = DirNode.new_root

  rows = lines.map(&:strip).reject(&:empty?).map(&:split)

  rows.each do |lede, command_or_name, *rest|
    case lede
    when '$'
      next if command_or_name == 'ls'
      raise "unknown command #{command_or_name}" if command_or_name != 'cd'
      raise "cd needs exactly 1 argument, got #{rest.size}" if rest.size != 1

      node = resolve(node, rest[0])

    when 'dir'
      raise 'extraneous field after directory name' unless rest.empty?

      node.make_dir(command_or_name)

    when /\A\d+\z/
      raise 'extraneous field after file name' unless rest.empty?

      node.make_file(name: command_or_name, size: lede.to_i)

    else
      raise "unrecognized leading token: #{lede}"
    end
  end

  root
end

def parse_options
  options = {
    cutoff: DEFAULT_CUTOFF,
    verbose: false
  }

  OptionParser.new do |parser|
    parser.on('-c', '--cutoff CUTOFF',
              "Total size cutoff (default: #{DEFAULT_CUTOFF})") do |arg|
      options[:cutoff] = Integer(arg)
    end
    parser.on('-v', '--verbose', 'List each matching directory') do
      options[:verbose] = true
    end
    parser.on('-h', '--help', 'Print this help message') do
      puts parser
      exit
    end
  end.parse!

  options
end

def run
  options = parse_options
  puts "Size cutoff is #{options[:cutoff]}.\n" if options[:verbose]

  root = build_tree(ARGF)
  total = 0

  root.total_sizes do |dir, size|
    next if size > options[:cutoff]

    puts "#{dir.path} (#{size})" if options[:verbose]
    total += size
  end

  if options[:verbose]
    puts "\nSum of total sizes of matching directories is #{total}."
  else
    puts total
  end
end

run if $PROGRAM_NAME == __FILE__
