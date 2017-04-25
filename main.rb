#!/usr/bin/env bundle exec ruby -w
require 'yaml'
require 'pry'
require_relative 'carer/carer.rb'
require_relative 'carer/config.rb'

carer = Carer.new(verbose: ARGV[0])

while true do
  carer.check!
  print %x{clear}
  puts Carer.header
  puts carer.checks
  sleep carer.config.refresh_time
end

