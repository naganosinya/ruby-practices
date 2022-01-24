#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'optparse'
require 'etc'

FILE_TYPE = {
  file: '-',
  directory: 'd',
  characterSpecial: 'c',
  blockSpecial: 'b',
  fifo: 'p',
  link: 'l',
  socket: 's'
}.freeze

FILE_MODE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

@option = {}

def option_parse
  opt = OptionParser.new
  opt.on('-l') { |boolean| @option[:l] = boolean }
  opt.parse(ARGV)
end

def define_directory
  Dir.glob('*')
end

def option_l?
  @option.key?(:l)
end

def display_column
  max_column_length = 3.0
  display_column_num = (define_directory.size / max_column_length).ceil
  display_column_lists = define_directory.each_slice(display_column_num).to_a
  last_column = display_column_lists.last
  (display_column_num - last_column.size).times { last_column << '' }
  display_column_lists.transpose
end

def column_margin
  length = define_directory.map(&:length).max
  margin = 3
  length + margin
end

def get_permission(file_stat)
  file_stat.mode.to_s(8).chomp.split('')
end

def dispaly_l_option(file)
  fs = File.lstat(file)
  type = fs.ftype.to_sym
  mode = get_permission(fs)
  owner_permission = mode[-3]
  group_permission = mode[-2]
  other_permission = mode[-1]
  number_of_hard_links = fs.nlink
  user_name = Etc.getpwuid(fs.uid).name
  group_name = Etc.getgrgid(fs.gid).name
  file_size = fs.size
  update_time = fs.mtime.strftime('%_m %e %H:%M')

  print FILE_TYPE[type]
  print "#{FILE_MODE[owner_permission]}#{FILE_MODE[group_permission]}#{FILE_MODE[other_permission]} "
  print "#{number_of_hard_links} "
  print "#{user_name}  "
  print "#{group_name}  "
  print "#{file_size} ".rjust(5)
  print "#{update_time} "
  print file
  puts ''
end

def cal_total_blocks
  total_blocks = display_column.sum do |column|
    column.map do |file|
      File.lstat(file).blocks
    end.sum
  end
  "total #{total_blocks}"
end

def main
  option_parse
  puts cal_total_blocks if option_l?

  if option_l?
    define_directory.each do |file|
      dispaly_l_option(file)
    end
  else
    display_column.each do |column|
      column.each do |file|
        print file.ljust(column_margin)
      end
      puts ''
    end
  end
end

main
