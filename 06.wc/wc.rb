#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'optparse'

opt = OptionParser.new
@option = {}
opt.on('-l') { |v| @option[:l] = v }
opt.parse!(ARGV)

def cal_lines_count(file)
  file.lines.count
end

def cal_words_count(file)
  file.split(/\s+/).size
end

def display_file_info(file)
  lines_count = cal_lines_count(File.read(file))
  words_count = cal_words_count(File.read(file))
  bytes_count = File.size(file)

  print lines_count
  print " #{words_count} #{bytes_count}" unless @option[:l]
  print " #{file}\n"
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
    total_line << cal_lines_count(File.read(file))
    total_words << cal_words_count(File.read(file))
    total_bytes << File.size(file)
  end

  print total_line.sum
  print " #{total_words.sum} #{total_bytes.sum}" unless @option[:l]
  print ' total'
end

def display_input_info(content)
  line_count = cal_lines_count(content)

  print line_count
  print " #{cal_words_count(content)} #{content.size}" unless @option[:l]
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
