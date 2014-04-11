class AddCreatedByToContract < ActiveRecord::Migration
  def change
    add_column :contracts, :created_by, :integer
  end
end
