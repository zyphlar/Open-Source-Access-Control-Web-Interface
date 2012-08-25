class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :card_id
      t.string :card_number
      t.integer :card_permissions

      t.timestamps
    end
  end
end
