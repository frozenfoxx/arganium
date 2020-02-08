#!/usr/bin/env ruby
###########################################################
# Name:         finishscript_fslog.rb
# Date:         12/26/2016
# Author:       FOXX (frozenfoxx@github.com)
# Description:  logs the values of the game to a file.
###########################################################
require 'logger'
require 'optparse'

# Global variables
$verbose = false

# Default argument values
options = {:total => '', :time => '', :par => '', :kills => '', :secrets => '', :challenges=> ''}

# Check number of arguments and for if the user requests help
parser = OptionParser.new do |o|
  o.banner = "Usage: #{$0} <options>"
  o.on("--total TOTAL", "Total score") { |i| options[:total] = i }
  o.on("--time TIME", "Time taken") { |i| options[:time] = i }
  o.on("--par PAR", "Par time") { |i| options[:par] = i }
  o.on("--kills KILLS", "Demons killed") { |i| options[:kills] = i }
  o.on("--secrets SECRETS", "Secrets found") { |i| options[:secrets] = i }
  o.on("--challenges CHALLENGES", "Challenges completed score") { |i| options[:challenges] = i }
  o.on('-h') { puts o; exit }
end
parser.parse!

# Write to the log
log = Logger.new('/tmp/arganium-finishscript.log')
log.info "Arganium level complete."
log.info "Total:  #{options[:total]}"
log.info "Time:  #{options[:time]}"
log.info "Par:  #{options[:par]}"
log.info "Kills:  #{options[:kills]}"
log.info "Secrets:  #{options[:secrets]}"
log.info "Challenges:  #{options[:challenges]}"
