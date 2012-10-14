class AddNameToCards < ActiveRecord::Migration
  def change
    add_column :cards, :name, :string
  end
end
