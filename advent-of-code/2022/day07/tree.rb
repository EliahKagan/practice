# frozen_string_literal: true

# Some closely related classes for simulating a filesystem hierarchy.
module Tree
  # A leaf node in a simulated directory tree representing a regular file.
  class FileNode
    attr_reader :parent, :name, :path, :size

    def initialize(parent, name, size)
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

    def find_root
      node = self
      node = node.parent while node.parent
      node
    end

    # Recurses directories here and below, yielding each with its total size.
    # Returns the total size of *this* directory.
    def total_sizes(&)
      files_size = @files.each_value.sum(&:size)
      subdirs_size = @dirs.each_value.sum { |dir| dir.total_sizes(&) }
      size = files_size + subdirs_size
      yield self, size
      size
    end

    private

    def check_collision(name)
      raise "node already exists (as file): #{name}" if @files.key?(name)
      raise "node already exists (as directory): #{name}" if @dirs.key?(name)
    end
  end

  # Builder of directory trees (trees of DirNode and FileNode objects).
  class Builder
    def self.build_from(lines)
      builder = new
      lines.each { |line| builder.execute(line) }
      builder.build
    end

    def initialize
      @node = @root = DirNode.new_root
      @built = false
    end

    def execute(line)
      raise 'tree already built' if @built

      execute_tokens(*line.split) unless line =~ /\A\s*\z/
      nil
    end

    def build
      @built = true
      @root
    end

    private

    def execute_tokens(lede, command_or_name, *rest)
      case lede
      when '$'
        execute_like_shell(command: command_or_name, args: rest)

      when 'dir'
        raise 'extraneous field after directory name' unless rest.empty?

        @node.make_dir(command_or_name)

      when /\A\d+\z/
        raise 'extraneous field after file name' unless rest.empty?

        @node.make_file(name: command_or_name, size: lede.to_i)

      else
        raise "unrecognized leading token: #{lede}"
      end
    end

    def execute_like_shell(command:, args:)
      return if command == 'ls'
      raise "unknown command #{command}" if command != 'cd'
      raise "cd needs exactly 1 argument, got #{args.size}" if args.size != 1

      change_dir(args[0])
    end

    def change_dir(target)
      case target
      when '/'
        @node = @node.find_root
      when '..'
        # "cd .." from the root would stay here, but that may be unintended.
        raise 'ambiguous "cd .." from the root directory' unless @node.parent

        @node = @node.parent
      else
        @node = @node.get_dir(target)
      end
    end
  end
end
