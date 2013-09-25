class ChangeUserExitReasonToText < ActiveRecord::Migration
  def up
    change_column :users, :exit_reason, :text, :limit => nil
  end

  def down
    change_column :users, :exit_reason, :string
  end
end
