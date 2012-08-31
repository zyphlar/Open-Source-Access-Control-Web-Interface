class DoorLog < ActiveRecord::Base
  attr_accessible :data, :key
  require 'open-uri'

  def self.download_from_door
    # do shit here
    source = open("http://192.168.1.177?e=1234").read
    results = source.scan(/authok/)
    if(results.size > 0) then
      @end_results = Array.new

      #only continue if we've got an OK login
      source = open("http://192.168.1.177?z").read
      results = source.scan(/(.*): (.*)\r\n/)

      results.each do |r|
        if(r[0] != "\000") then
          DoorLog.create!({:key => r[0], :data => r[1]})
        end
      end

      #clear log
      open("http://192.168.1.177?y")
      #logout
      open("http://192.168.1.177?e=0000")

      if(results.size > 0) then
        #only return true if we got some kind of decent response
        return results
      else
        # We didn't get a decent response.
        return false
      end
    else
      # We didn't get an OK login.
      return false
    end
  end

end
