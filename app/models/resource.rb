class Resource < ActiveRecord::Base
  belongs_to :owner, :class_name => "ToolshareUser" #TODO: remove owner
  belongs_to :user
  belongs_to :category, :class_name => "ResourceCategory"
  has_attached_file :picture,  #TODO: move to local storage
                    :styles => { :medium => "300x300>",
	                         :thumb => "100x100>",
				 :tiny => "50x50>"},
                    :storage => :s3,
                    :s3_credentials => Rails.root.join('config', 's3.yml'),
                    :path => ":attachment/:id/:style.:extension",
                    :bucket => 'Toolshare'

  def category_name
    self.category.name if self.category
  end
end
