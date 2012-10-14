class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :card_number
      t.integer :card_permissions

      t.timestamps
    end
  end
end
