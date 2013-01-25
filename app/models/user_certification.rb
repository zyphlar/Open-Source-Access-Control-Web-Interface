class UserCertification < ActiveRecord::Base
  attr_accessible :certification_id, :user_id
  belongs_to :user
  belongs_to :certification
end
