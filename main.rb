#!/usr/bin/env bundle exec ruby -w
require 'yaml'
require 'pry'
require 'pp'
require_relative 'carer/carer.rb'
require_relative 'carer/config.rb'
require_relative 'carer/mailer.rb'

carer = Carer.new(verbose: ARGV[0])

while true do
  carer.check!
  print %x{clear}
  puts Carer.header
  pp carer.checks
  puts "--------------------"
  puts carer.logs.reverse.last(10)
  carer.clear_logs!

  sleep carer.config.refresh_time
end

