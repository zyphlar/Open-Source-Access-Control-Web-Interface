class RenameResourceCategoryIdToResourceResourceCategoryId < ActiveRecord::Migration
  def change
    rename_column :resources, :category_id, :resource_category_id
  end
end
