class AddAmountToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :amount, :decimal
  end
end
