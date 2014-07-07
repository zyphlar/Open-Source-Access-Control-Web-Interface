class ChangeUsersMemberToInteger < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE users ALTER COLUMN member TYPE integer USING (member::integer)'
  end

  def down
    execute 'ALTER TABLE users ALTER COLUMN member TYPE text USING (member::text)'
  end
end
