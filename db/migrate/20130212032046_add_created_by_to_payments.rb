class AddCreatedByToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :created_by, :integer
  end
end
