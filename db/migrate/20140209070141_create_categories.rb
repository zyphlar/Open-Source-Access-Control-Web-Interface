class CreateCategories < ActiveRecord::Migration
  def up
    create_table "resource_categories", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "parent"
    end
  end

  def down
    drop_table :resource_categories
  end
end
