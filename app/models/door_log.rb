class DoorLog < ActiveRecord::Base
  attr_accessible :data, :key
  require 'open-uri'

  def self.show_status
    door_logs = DoorLog.where(key: ["door_1_locked","door_2_locked"]).order('created_at DESC').take(2)
    door_1_locked = parse_locked_status(door_logs, "door_1_locked")
    door_2_locked = parse_locked_status(door_logs, "door_2_locked")

    # Doors are unlocked if 1 AND 2 are NOT locked
    status = {:unlocked => (!door_1_locked && !door_2_locked), :door_1_locked => door_1_locked, :door_2_locked => door_2_locked }
  end

  def self.parse_locked_status(door_logs, door_key)
    door_logs_selected = door_logs.select{|s| s.key == door_key }
    if door_logs_selected.present?
      door_data = door_logs_selected.first.data
      if door_data == 0 # 0 = unlocked
        return false
      else
        return true # 1 = locked
      end
    end 
  end

  def self.download_status
    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    # query for status
    source = open("#{door_access_url}?9").read
    # expect {"armed"=>255, "activated"=>255, "alarm_3"=>1, "alarm_2"=>1, "door_1_locked"=>1, "door_2_locked"=>1}
    # See https://github.com/heatsynclabs/Open_Access_Control_Ethernet for more info 
    @status = JSON.parse(source)
    @status.each do |key,value|
      DoorLog.create!({:key => key, :data => value})
    end
  end

  def self.download_from_door
    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    # connect to door access system
    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/ok/)
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

  def self.key_legend
    {'G' => "Granted", "R" => "Read", "D" => "Denied",
    'g' => "granted", "r" => "read", "d" => "denied"}
  end
end
