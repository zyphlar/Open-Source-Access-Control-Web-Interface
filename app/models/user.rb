class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin, :instructor, :active, :emergency_name, :emergency_phone, :current_skills, :desired_skills, :waiver, :emergency_email, :phone, :payment_method, :orientation, :member_level, :certifications

  has_many :cards
  has_many :user_certifications
  has_many :certifications, :through => :user_certifications
end
