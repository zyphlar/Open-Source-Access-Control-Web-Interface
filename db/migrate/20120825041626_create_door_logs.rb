class CreateDoorLogs < ActiveRecord::Migration
  def change
    create_table :door_logs do |t|
      t.string :key
      t.integer :data

      t.timestamps
    end
  end
end
