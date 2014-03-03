class Resource < ActiveRecord::Base
  attr_accessible :supercategory, :user_id, :resource_category_id, :name, :serial, :specs, :status, :donatable, 
:picture, :picture_file_name, :picture_content_type, :picture_file_size, :picture_updated_at,
:picture2, :picture2_file_name, :picture2_content_type, :picture2_file_size, :picture2_updated_at,
:picture3, :picture3_file_name, :picture3_content_type, :picture3_file_size, :picture3_updated_at,
:picture4, :picture4_file_name, :picture4_content_type, :picture4_file_size, :picture4_updated_at,
 :notes, :estimated_value, :disposed_at, :modified_by

  belongs_to :owner, :class_name => "ToolshareUser" #TODO: remove owner
  belongs_to :user
  belongs_to :resource_category

  PICTURE_OPTIONS = { :styles => { :medium => "300x300>",
                                   :thumb => "100x100>",
                                   :tiny => "50x50>"},
                      :storage => :s3,
                      :s3_credentials => { :access_key_id     => ENV['S3_KEY'], 
                                         :secret_access_key => ENV['S3_SECRET'] },
                      :path => ":attachment/:id/:style.:extension",
                      :bucket => ENV['S3_BUCKET'] }

  has_attached_file :picture, PICTURE_OPTIONS
  has_attached_file :picture2, PICTURE_OPTIONS  
  has_attached_file :picture3, PICTURE_OPTIONS  
  has_attached_file :picture4, PICTURE_OPTIONS  

  def resource_category_name
    resource_category.name if resource_category
  end
end
