class ChangeUsersMemberToInteger < ActiveRecord::Migration
  def change
    change_column :users, :member, :integer
  end
end
