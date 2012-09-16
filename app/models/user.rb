class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  require 'open-uri'

  attr_accessible :card_id, :card_number, :card_permissions, :name, :admin
  validates_uniqueness_of :card_id, :card_number 


  def upload_to_door
    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    # connect to door access system
    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/authok/)
    if(results.size > 0) then
      #only continue if we've got an OK login
      usernum = self.card_id.to_s.rjust(3, '0')
      userperm = self.card_permissions.to_s.rjust(3, '0')
      cardnum = self.card_number.rjust(8, '0')

      source = open("#{door_access_url}?m#{usernum}&p#{userperm}&t#{cardnum}").read
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
    @users = User.all
    @end_results = Array.new

    # load config values
    door_access_url = APP_CONFIG['door_access_url']
    door_access_password = APP_CONFIG['door_access_password']

    source = open("#{door_access_url}?e=#{door_access_password}").read
    results = source.scan(/authok/)
    if(results.size > 0) then
      @users.each do |u|
        #only continue if we've got an OK login
        usernum = u.card_id.to_s.rjust(3, '0')
        userperm = u.card_permissions.to_s.rjust(3, '0')
        cardnum = u.card_number.rjust(8, '0')

        source = open("#{door_access_url}?m#{usernum}&p#{userperm}&t#{cardnum}").read
        results = source.scan(/cur/)

        if(results.size > 0) then
          #only return true if we got some kind of decent response
          @end_results.push([usernum,"OK"])
        else
          @end_results.push([usernum,"FAIL"])
        end
      end

      #logout
      open("#{door_access_url}?e=0000")
    else
      @end_results.push([usernum,"FAIL"])
    end

    return @end_results
  end
end
