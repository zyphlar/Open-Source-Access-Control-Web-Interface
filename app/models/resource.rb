class Resource < ActiveRecord::Base
  belongs_to :owner, :class_name => "ToolshareUser"
  belongs_to :category, :class_name => "ResourceCategory"
  has_attached_file :picture, 
                    :styles => { :medium => "300x300>",
	                         :thumb => "100x100>",
				 :tiny => "50x50>"},
                    :storage => :s3,
                    :s3_credentials => Rails.root.join('config', 's3.yml'),
                    :path => ":attachment/:id/:style.:extension",
                    :bucket => 'Toolshare'
end
