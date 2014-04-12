class Contract < ActiveRecord::Base
  belongs_to :user
  belongs_to :created_by, :foreign_key => "created_by_id", :class_name => "User"
  attr_accessible :user_id, :first_name, :last_name, :cosigner, 
    :signed_at, :document, :document_file_name, :document_content_type, 
    :document_file_size, :document_updated_at
    # :created_by not accessible for security purposes

  validates_presence_of :first_name, :signed_at #, :last_name

  has_attached_file :document, 
                    { :styles => 
                      {
                        :medium => "300x300>",
                        :large => "900x900>"
                      },
                      :storage => :s3,
                      :s3_protocol => :https,
                      :s3_credentials => { :access_key_id     => ENV['S3_KEY'], 
                                         :secret_access_key => ENV['S3_SECRET'] },
                      :path => ":attachment/:id/:style.:extension",
                      :bucket => ENV['S3_BUCKET'] 
                    }
end
