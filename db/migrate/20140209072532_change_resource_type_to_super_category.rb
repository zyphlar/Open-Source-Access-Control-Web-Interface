class ChangeResourceTypeToSuperCategory < ActiveRecord::Migration
  def change
    rename_column :resources, :type, :supercategory
  end
end
