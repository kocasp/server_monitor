#!/usr/bin/env bundle exec ruby -w
require 'yaml'
require 'pry'
require 'pp'
require_relative 'carer/control.rb'
require_relative 'carer/carer.rb'
require_relative 'carer/config.rb'
require_relative 'carer/mailer.rb'
require_relative 'carer/control/connection.rb'
require_relative 'carer/control/custom.rb'
require_relative 'carer/control/directories.rb'
require_relative 'carer/control/memory.rb'

carer = Carer.new(verbose: ARGV[0])
# binding.pry
while true do
  carer.perform_controls!
  print %x{clear}
  puts Carer.header
  carer.checks.each{|c| p c}
  puts "--------------------"

  sleep carer.config.refresh_time
end

