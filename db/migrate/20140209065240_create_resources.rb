class CreateResources < ActiveRecord::Migration
  def up
    create_table "resources", :force => true do |t|
      t.string   "type"
      t.integer  "owner_id"
      t.integer  "category_id"
      t.string   "name"
      t.string   "serial"
      t.string   "specs"
      t.string   "status"
      t.boolean  "donatable"
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.integer  "picture_file_size"
      t.datetime "picture_updated_at"
      t.text     "notes"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "estimated_value"
    end
  end

  def down
    drop_table :resources
  end
end
