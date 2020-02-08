#!/usr/bin/env ruby
###########################################################
# Name:         Certain
# Date:         10/06/2015
# Author:       FOXX (frozenfoxx@github.com)
# Description:  Certain is a wrapper script for Zandronum
#  that is intended to be used with Arganium.
###########################################################
require_relative "../lib/libcertain.rb"
require "optparse"

# Global variables
$stdout.sync = true

# Default argument values
options = {:wadfiles => [], :assets => ['arganium.pk3'], :iwad => "", :level => ""}

# Check number of arguments and for if the user requests help
parser = OptionParser.new do |o|
  o.banner = "Usage: #{$0} <options>"
  o.on("--wadfiles A,B,C[...]", Array, "WAD files to run the server with") { |wads| options[:wadfiles] = wads }
  o.on("--assets D,E,F[...]", Array, "Asset files to load in Certain") { |files| options[:assets] = files }
  o.on("--iwad IWAD", "IWAD file") { |iwad| options[:iwad] = iwad }
  o.on("--marines NUM", "Number of Marines") { |i| options[:marines] = i }
  o.on("--level LEVEL", "Level to load") { |level| options[:level] = level }
  o.on('-h') { puts o; exit }
end
parser.parse!

puts "Certain launching..."

# Initialize GameServer object
gameServer = GameServer.new(options[:iwad], options[:assets], options[:wadfiles], options[:marines], options[:level])

gameServer.start
