#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require 'optparse'

def main
  ARGV.each do |file|
    print "#{File.open(file).read.count("\n")}  "
    print "#{File.read(file).split(/\s+/).size}  "
    print "#{FileTest.size(file)}  "
    puts file
  end
end

main
