#!/usr/bin/env ruby
###############################################################################
#
# 23b interface to SpaceAPI (https://hackerspaces.nl/spaceapi/)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#    
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#    
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2011 Ryan Rix <ry@n.rix.si>
#
###############################################################################

#config = []
#config['space_name'] = "HeatSync Labs"

require 'rubygems'
require 'cgi'
require 'serialport'
require 'json'

#cgi = CGI.new
json = JSON.parse(File.read("spaceapi.conf"))

puts "Content-type: text/json \r\n\r\n"

# Basically, this is nicked from access.rb

# start by getting the current status of the lock system
serial = SerialPort.new("/dev/ttyUSB0", 57600, 8, 1, SerialPort::NONE)
serial.print "e 1234\r"

# query for status
serial.print "9\r"
sleep 1
serial.read_timeout = 1000
lines = serial.readlines

# ugly as shit
caps = []
for line in lines
    if m = /\(\d=(\w*)\)/.match(line) then
        caps << m.captures
    end
end

# more ugly. Space is open when the doors are open or unlocked
hs_open = false # because when is anyone open these days?

if caps[2] == "open" then hs_open = true end
if caps[3] == "open" then hs_open = true end
if caps[4] == "unlocked" then hs_open = true end
if caps[5] == "unlocked" then hs_open = true end

#take all those nice unformatted garbages from 23b and put'm in a json

json["open"] = hs_open

puts JSON.generate json