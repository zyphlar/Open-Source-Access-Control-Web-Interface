class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user
      t.date :date

      t.timestamps
    end
    add_index :payments, :user_id
  end
end
