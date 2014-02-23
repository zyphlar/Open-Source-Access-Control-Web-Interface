class Certification < ActiveRecord::Base
  attr_accessible :description, :name, :slug
  has_many :user_certifications
  has_many :users, :through => :user_certifications

  validates_presence_of :name, :slug
end
