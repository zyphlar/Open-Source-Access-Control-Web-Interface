class CreateIpns < ActiveRecord::Migration
  def change
    create_table :ipns do |t|
      t.integer :payment_id
      t.text :data
      t.string :txn_id
      t.string :txn_type
      t.string :first_name
      t.string :last_name
      t.string :payer_business_name
      t.string :payer_email
      t.string :payer_id
      t.string :auth_amount
      t.string :payment_date
      t.string :payment_fee
      t.string :payment_gross
      t.string :payment_status
      t.string :item_name
      t.string :payment_type

      t.timestamps
    end
  end
end
