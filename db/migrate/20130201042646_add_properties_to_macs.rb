class AddPropertiesToMacs < ActiveRecord::Migration
  def change
    add_column :macs, :hidden, :boolean
    add_column :macs, :note, :string
  end
end
