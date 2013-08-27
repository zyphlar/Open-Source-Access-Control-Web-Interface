class UserCertification < ActiveRecord::Base
  attr_accessible :certification_id, :user_id

  validates_uniqueness_of :certification_id, :scope => :user_id, :message => 'already exists for this user.'  # Makes sure users don't get certified twice

  belongs_to :user
  belongs_to :certification

  def user_name
    self.user.name unless self.user.blank?
  end
end
