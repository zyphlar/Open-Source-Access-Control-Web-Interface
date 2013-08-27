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

    # connect to door access system
    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/ok/)
    if(results.size > 0) then
      #only continue if we've got an OK login
      cardid = self.id.to_s.rjust(3, '0')  #TODO: provide ability for 
      cardperm = self.card_permissions.to_s.rjust(3, '0')
      cardnum = self.card_number.rjust(8, '0')

      source = open("#{door_access_url}?m#{cardid}&p#{cardperm}&t#{cardnum}").read
      results = source.scan(/cur/)

      #logout
      open("#{door_access_url}?e=0000")

      if(results.size > 0) then
        #only return true if we got some kind of decent response
        return true
      else
        # We didn't get a decent response.
        return false
      end
    else
      # We didn't get an OK login.
      return false
    end
  end

  def self.upload_all_to_door
    @cards = Card.all
    @end_results = Array.new

    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/ok/)
    if(results.size > 0) then
      @cards.each do |u|
        #only continue if we've got an OK login
        cardid = u.id.to_s.rjust(3, '0')
        cardperm = u.card_permissions.to_s.rjust(3, '0')
        cardnum = u.card_number.rjust(8, '0')

        source = open("#{door_access_url}?m#{cardid}&p#{cardperm}&t#{cardnum}").read
        results = source.scan(/cur/)

        if(results.size > 0) then
          #only return true if we got some kind of decent response
          @end_results.push([cardid,"OK"])
        else
          @end_results.push([cardid,"FAIL"])
        end
      end

      #logout
      open("#{door_access_url}?e=0000")
    else
      @end_results.push([cardid,"FAIL"])
    end

    return @end_results
  end
end
