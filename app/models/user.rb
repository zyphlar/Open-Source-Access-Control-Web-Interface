class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin, :instructor, :member, :emergency_name, :emergency_phone, :current_skills, :desired_skills, :waiver, :emergency_email, :phone, :payment_method, :orientation, :member_level, :certifications, :hidden #TODO: make admin/instructor/member/etc not accessible

  has_many :cards
  has_many :user_certifications
  has_many :certifications, :through => :user_certifications

  def member_status
    output = ""

    if self.member_level.to_i >= 1 then
       output = "<span class='hoverinfo' title='Inactive'>&#9676;</span>"
    end

    unless self.member.nil? then
      # 1 = inactive, show an X
      if self.member >= 10 then
         output = "<span class='hoverinfo' title='Volunteer'>&#9684;</span>"
      # 25 or higher is paying, show a check
      end
      if self.member >= 25 then
         output = "<span class='hoverinfo' title='25'>&#9681;</span>"
      end
      if self.member >= 50 then
         output = "<span class='hoverinfo' title='50'>&#9685;</span>"
      end
      if self.member >= 100 then
         output = "<span class='hoverinfo' title='100'>&#9679;</span>"
      end
      
      if self.member < self.member_level.to_i then
         output = "<span class='hoverinfo' title='Lapsed'>&#x2717;</span>"
      end
    end
    
    return output
  end
end
