class ChangeMemberLevelToInteger < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE users ALTER COLUMN member_level TYPE integer USING (member_level::integer)'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN member_level TYPE text USING (member_level::text)'
  end
end
