class RemoveCardFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :card_id
    remove_column :users, :card_number
    remove_column :users, :card_permissions
  end

  def down
    add_column :users, :card_id, :integer
    add_column :users, :card_number, :string
    add_column :users, :card_permissions, :integer
  end
end
