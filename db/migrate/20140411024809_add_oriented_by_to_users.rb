class AddOrientedByToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oriented_by_id, :integer
  end
end
