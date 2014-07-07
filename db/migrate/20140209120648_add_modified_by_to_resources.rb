class AddModifiedByToResources < ActiveRecord::Migration
  def change
    add_column :resources, :modified_by, :integer
  end
end
