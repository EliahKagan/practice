#!/usr/bin/env ruby
# frozen_string_literal: true

# https://www.hackerrank.com/challenges/simple-text-editor

$VERBOSE = 1

# Text buffer supporting appending and truncation, with undo capability.
class Editor
  def initialize
    @buffer = String.new
    @undos = []
  end

  def append(text)
    @buffer << text
    count = text.size
    @undos << -> { @buffer.slice!(-count..) }
    nil
  end

  def delete(count)
    text = @buffer.slice!(-count..)
    @undos << -> { @buffer << text }
    nil
  end

  def print(index)
    puts @buffer[index - 1]
  end

  def undo
    @undos.pop.call
    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  editor = Editor.new

  gets.to_i.times do
    tokens = gets.split

    case tokens[0].to_i
    when 1
      editor.append(tokens[1])
    when 2
      editor.delete(tokens[1].to_i)
    when 3
      editor.print(tokens[1].to_i)
    when 4
      editor.undo
    end
  end
end
