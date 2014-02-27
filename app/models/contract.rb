class Contract < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :first_name, :last_name, :signed_at, :document_file_name, :document_content_type, :document_file_size, :document_updated_at

  validates_presence_of :first_name, :last_name, :signed_at

  has_attached_file :document, { :styles => { :medium => "300x300>"},
                    :storage => :s3,
                    :s3_credentials => Rails.root.join('config', 's3.yml'),
                    :path => ":attachment/:id/:style.:extension",
                    :bucket => 'Toolshare' }  #TODO: move to local storage
end
