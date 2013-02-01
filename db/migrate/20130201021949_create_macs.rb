class CreateMacs < ActiveRecord::Migration
  def change
    create_table :macs do |t|
      t.references :user
      t.string :mac
      t.string :ip
      t.datetime :since
      t.datetime :refreshed
      t.boolean :active

      t.timestamps
    end
    add_index :macs, :user_id
  end
end
