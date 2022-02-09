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

  if @option[:l] == true
    puts "#{count_lines} #{file}"
  else
    puts "#{count_lines} #{count_words} #{count_bytes} #{file}"
  end
end

def defile_file(argv)
  argv.each do |file|
    display_file_info(file)
  end
end

def display_input_info(content)
  if @option[:l] == true
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
  end
end

main
