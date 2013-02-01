class CreateMacLogs < ActiveRecord::Migration
  def change
    create_table :mac_logs do |t|
      t.string :mac
      t.string :ip
      t.string :action

      t.timestamps
    end
  end
end
