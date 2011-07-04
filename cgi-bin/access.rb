#!/usr/bin/env ruby

# Copyright 2011 Ryan Rix <ry@n.rix.si>
#
# Released under the Chicken Dance License, as detailed
# http://supertunaman.com/cdl/cdl_v0-1.txt
#
# Ruby interface to 23b's Open Access Control system
# By Ryan Rix, twitter.com/rrrrrrrix of HeatSync Labs
#
# Valid access control commands:
#(d)ate, (s)show user, (m)odify user <num>  <usermask> <tagnumber>
#(a)ll user dump,(r)emove_user <num>,(o)open door <num>
#(u)nlock all doors,(l)lock all doors
#(1)disarm_alarm, (2)arm_alarm,(3)train_alarm (9)show_status
#(e)nable <password> - enable or disable priveleged mode

require 'rubygems'
require 'cgi'
require 'serialport'
require 'json'
require 'digest/sha2'

cgi = CGI.new
userfile = File.read('../../users.json')
users = JSON.parse(userfile)

puts "Content-type: text/html \r\n\r\n"

if users[cgi['user']]['pass'].to_s == (Digest::SHA2.new(bitlen=512) << cgi['pass']).to_s then

  2.times do #do the serial stuff twice as sometimes the serial port is occupied
    
    serial = SerialPort.new("/dev/ttyUSB0", 57600, 8, 1, SerialPort::NONE)
    serial.print "e 1234\r"

    case cgi['cmd']
    when "open-front"  
      puts "Front door opened."
      serial.print "o 1\r"
    when "open-rear"
      puts "Rear door opened."
      serial.print "o 2\r"
    when "unlock"  
      puts "Doors unlocked, remember to re-lock them."
      serial.print "u\r"
    when "lock"  
      puts "Doors locked."
      serial.print "l\r"
    when "arm"  
      if(users[cgi['user']]['admin'] == true) then
        puts "Armed."
        serial.print "2\r"
      else
        puts "Fail. Don't be a naughty user!"
      end
    when "disarm"  
      if(users[cgi['user']]['admin'] == true) then
        puts "Disarmed."
        serial.print "1\r"
      else
        puts "Fail. Don't be a naughty user!"
      end
    else 
      puts "Fail. Don't be a naughty user!"
    end

    serial.close
    puts ' <a href="/~access">Return.</a>'

  end

else
  puts "Invalid username or password."
end
