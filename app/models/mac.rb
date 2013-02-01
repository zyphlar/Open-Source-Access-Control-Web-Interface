class Mac < ActiveRecord::Base
  belongs_to :user
  attr_accessible :active, :ip, :mac, :refreshed, :since
end
