class AddAccountantToUsers < ActiveRecord::Migration
  def change
    add_column :users, :accountant, :boolean
  end
end
