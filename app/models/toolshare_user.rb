class ToolshareUser < ActiveRecord::Base
  has_many :resources, :foreign_key => "owner_id"
  attr_accessible :name, :email
end
