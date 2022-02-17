#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'optparse'

opt = OptionParser.new
@option = {}
opt.on('-l') { |v| @option[:l] = v }
opt.parse!(ARGV)

def display_file_info(file)
  count_lines = File.read(file).lines.count
  count_words = File.read(file).split(/\s+/).size
  count_bytes = File.size(file)

  print count_lines
  if @option[:l]
    puts file
  else
    print " #{count_words} #{count_bytes} #{file}\n"
  end
end

def defile_file(argv)
  argv.each do |file|
    display_file_info(file)
  end
end

def display_total(argv)
  total_line = []
  total_words = []
  total_bytes = []

  argv.each do |file|
    total_line << File.read(file).lines.count
    total_words << File.read(file).split(/\s+/).size
    total_bytes << File.size(file)
  end

  puts "#{total_line.sum} #{total_words.sum} #{total_bytes.sum} total"
end

def display_input_info(content)
  if @option[:l]
    puts content.lines.count.to_s
  else
    puts "#{content.to_s.lines.count} #{content.split(/\s+/).size} #{content.size}"
  end
end

def main
  if ARGV.size.zero?
    display_input_info($stdin.read)
  else
    defile_file(ARGV)
    display_total(ARGV) if ARGV.size >= 2
  end
end

main
