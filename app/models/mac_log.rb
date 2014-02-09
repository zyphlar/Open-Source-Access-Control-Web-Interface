class MacLog < ActiveRecord::Base
  attr_accessible :action, :ip, :mac

  scope :desc, order("mac_logs.created_at DESC")
end
