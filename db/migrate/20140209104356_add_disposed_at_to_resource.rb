class AddDisposedAtToResource < ActiveRecord::Migration
  def change
    add_column :resources, :disposed_at, :datetime
  end
end
