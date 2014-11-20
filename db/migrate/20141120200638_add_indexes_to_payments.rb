class AddIndexesToPayments < ActiveRecord::Migration
  def change
    add_index :payments, :date
    add_index :payments, :amount
  end
end
