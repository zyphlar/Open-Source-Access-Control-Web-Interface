class Certification < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :user_certifications
  has_many :users, :through => :user_certifications
end
