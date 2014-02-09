class Mac < ActiveRecord::Base
  belongs_to :user
  attr_accessible :active, :ip, :mac, :refreshed, :since, :hidden, :note, :user_id

  validates_uniqueness_of :mac, :case_sensitive => false
end
