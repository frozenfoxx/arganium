#!/usr/bin/env ruby
#######################################################
# Name:         finishscript_webserver.rb
# Author:       FOXX (frozenfoxx@github.com)
# Description:  this example finish script for Arganium
#   will spawn a webserver and display a file.
#######################################################
require 'socket'

webserver = TCPServer.new('127.0.0.1', 8080)
while (session = webserver.accept)
  session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
  request = session.gets
  trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
  filename = trimmedrequest.chomp
  if filename == ''
    filename = File.dirname(__FILE__) + '/finishscript_webserver.html'
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
