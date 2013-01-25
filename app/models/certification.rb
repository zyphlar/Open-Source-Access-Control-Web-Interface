class Certification < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :users, :through => :certifications_users
end
