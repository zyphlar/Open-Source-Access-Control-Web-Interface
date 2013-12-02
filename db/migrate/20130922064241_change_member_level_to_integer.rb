class ChangeMemberLevelToInteger < ActiveRecord::Migration
  def up
    change_column :users, :member_level, :integer
  end

  def down
    change_column :users, :member_level, :string
  end
end
