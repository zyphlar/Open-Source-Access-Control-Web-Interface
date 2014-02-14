class AddMorePicturesToResources < ActiveRecord::Migration
  def change
    add_column :resources, :picture2_file_name, :string
    add_column :resources, :picture2_content_type, :string
    add_column :resources, :picture2_file_size, :integer
    add_column :resources, :picture2_updated_at, :datetime
    add_column :resources, :picture3_file_name, :string
    add_column :resources, :picture3_content_type, :string
    add_column :resources, :picture3_file_size, :integer
    add_column :resources, :picture3_updated_at, :datetime
    add_column :resources, :picture4_file_name, :string
    add_column :resources, :picture4_content_type, :string
    add_column :resources, :picture4_file_size, :integer
    add_column :resources, :picture4_updated_at, :datetime
  end
end
