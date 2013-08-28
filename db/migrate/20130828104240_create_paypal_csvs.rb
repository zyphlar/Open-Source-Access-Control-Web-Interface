class CreatePaypalCsvs < ActiveRecord::Migration
  def change
    create_table :paypal_csvs do |t|
      t.integer :payment_id
      t.text :data
      t.string :date
      t.string :_time
      t.string :_time_zone
      t.string :_name
      t.string :_type
      t.string :_status
      t.string :_currency
      t.string :_gross
      t.string :_fee
      t.string :_net
      t.string :_from_email_address
      t.string :_to_email_address
      t.string :_transaction_id
      t.string :_counterparty_status
      t.string :_address_status
      t.string :_item_title
      t.string :_item_id
      t.string :string

      t.timestamps
    end
  end
end
