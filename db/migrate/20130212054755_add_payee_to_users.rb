class AddPayeeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payee, :string
  end
end
