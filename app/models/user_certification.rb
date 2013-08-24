class UserCertification < ActiveRecord::Base
  attr_accessible :certification_id, :user_id

  validates_uniqueness_of :certification_id, :scope => :user_id, :message => 'already exists for this user.'  # Makes sure users don't get certified twice

  belongs_to :user
  belongs_to :certification

  def user_name   
    if user.blank?
      return "n/a (user ##{user_id} missing)"
    else
      return self.user.name 
    end
  end
end
