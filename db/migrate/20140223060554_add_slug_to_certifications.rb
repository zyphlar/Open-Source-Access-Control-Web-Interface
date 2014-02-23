class AddSlugToCertifications < ActiveRecord::Migration
  def change
    add_column :certifications, :slug, :string
  end
end
