class Card < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :id, :user_id, :name, :card_number, :card_permissions
  validates_presence_of :user_id, :card_number, :card_permissions
  validates_uniqueness_of :id, :card_number
  belongs_to :user

  def upload_to_door
    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

      cardid = self.id.to_s.rjust(3, '0')
      cardperm = self.card_permissions.to_s.rjust(3, '0')
      cardnum = self.card_number.rjust(8, '0')

      # login and send the command all in one go (auto-logout is a feature of the arduino when used this way)
      source = open("#{door_access_url}?m#{cardid}&p#{cardperm}&t#{cardnum}&e=#{door_access_password}").read
      results = source.scan(/cur/)

      if(results.size > 0) then
        #only return true if we got some kind of decent response
        return true
      else
        # We didn't get a decent response.
        return false
      end
  end

  def self.upload_all_to_door
    @cards = Card.all
    @end_results = Array.new

    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    @cards.each do |u|
      cardid = u.id.to_s.rjust(3, '0')
      cardperm = u.card_permissions.to_s.rjust(3, '0')
      cardnum = u.card_number.rjust(8, '0')

      # login and send the command all in one go (auto-logout is a feature of the arduino when used this way)
      source = open("#{door_access_url}?m#{cardid}&p#{cardperm}&t#{cardnum}&e=#{door_access_password}").read
      results = source.scan(/cur/)

      if(results.size > 0) then
        #only return true if we got some kind of decent response
        @end_results.push([cardid,"OK"])
      else
        @end_results.push([cardid,"FAIL"])
      end
    end

    return @end_results
  end
end
