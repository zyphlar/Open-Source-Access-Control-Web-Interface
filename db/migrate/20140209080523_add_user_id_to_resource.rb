class AddUserIdToResource < ActiveRecord::Migration
  def change
    add_column :resources, :user_id, :integer
  end
end
