class DoorLog < ActiveRecord::Base
  attr_accessible :data, :key
  require 'open-uri'

  def self.download_from_door
    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    # connect to door access system
    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/authok/)
    if(results.size > 0) then
      @end_results = Array.new

      #only continue if we've got an OK login
      source = open("#{door_access_url}?z").read
      results = source.scan(/(.*): (.*)\r\n/)

      results.each do |r|
        if(r[0] != "\000") then
          DoorLog.create!({:key => r[0], :data => r[1]})
        end
      end

      #clear log
      open("#{door_access_url}?y")
      #logout
      open("#{door_access_url}?e=0000")

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
