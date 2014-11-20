class AddIndexesToDoorLog < ActiveRecord::Migration
  def change
    add_index :door_logs, :key
    add_index :door_logs, :created_at
  end
end
