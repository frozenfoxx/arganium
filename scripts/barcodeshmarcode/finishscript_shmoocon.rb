#!/usr/bin/env ruby
#######################################################
# Name:         finishscript_webserver.rb
# Author:       FOXX (frozenfoxx@github.com)
# Description:  this dynamically writes a file and
#   starts a webserver for Shmoocon 2017.
#######################################################
require 'socket'
require 'optparse'

# Global variables
currentDir = File.dirname(__FILE__)

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

# Generate index.html
`erb time=#{options[:time]} par=#{options[:par]} kills=#{options[:kills]} secrets=#{options[:secrets]} challenges=#{options[:challenges]} total=#{options[:total]} currentdir=#{currentDir} #{currentDir}/index.html.erb > #{currentDir}/index.html`

webserver = TCPServer.new('0.0.0.0', 8080)
while (session = webserver.accept)
  session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
  request = session.gets
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
  filename = trimmedrequest.chomp
  if filename == ''
    filename = File.dirname(__FILE__) + '/index.html'
  elsif filename =~ /^.*\.png$/
    filename = File.dirname(__FILE__) + "/#{filename}"
  end
  begin
    displayfile = File.open(filename, 'r')
    content = displayfile.read()
    session.print content
  rescue Errno::ENOENT
    session.print "File not found"
  end
  session.close
end
