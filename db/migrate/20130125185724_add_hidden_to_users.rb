class AddHiddenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hidden, :boolean
  end
end
