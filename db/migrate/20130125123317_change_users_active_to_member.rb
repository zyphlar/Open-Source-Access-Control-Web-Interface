class ChangeUsersActiveToMember < ActiveRecord::Migration
  def change
    change_column :users, :active, :string
    rename_column :users, :active, :member
  end
end
