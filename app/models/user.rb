class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin, :instructor, :member, :emergency_name, :emergency_phone, :current_skills, :desired_skills, :waiver, :emergency_email, :phone, :payment_method, :orientation, :member_level, :certifications, :hidden

  has_many :cards
  has_many :user_certifications
  has_many :certifications, :through => :user_certifications

  def member_status
    # 1 = inactive, show an X
    if self.member == 1 then
       "<span class='hoverinfo' title='Inactive'>!!</span>"
    # 25 or higher is paying, show a check
    elsif self.member == 25 then
       "<span class='hoverinfo' title='25'>&#x2713;</span>"
    elsif self.member == 50 then
       "<span class='hoverinfo' title='50'>&#x2713;</span>"
    elsif self.member == 100 then
       "<span class='hoverinfo' title='100'>&#x2713;</span>"
    end
  end
end
