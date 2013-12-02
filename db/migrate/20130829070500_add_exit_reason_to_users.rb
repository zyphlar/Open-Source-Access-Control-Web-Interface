class AddExitReasonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :exit_reason, :string
  end
end
