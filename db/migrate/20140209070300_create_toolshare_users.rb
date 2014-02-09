class CreateToolshareUsers < ActiveRecord::Migration
  def up
    create_table "toolshare_users", :force => true do |t|
      t.string   "email",                               :default => "", :null => false
      t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
      t.string   "password_salt",                       :default => "", :null => false
      t.string   "confirmation_token"
      t.datetime "confirmed_at"
      t.datetime "confirmation_sent_at"
      t.string   "reset_password_token"
      t.string   "remember_token"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",                       :default => 0
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
    end
  end

  def down
    drop_table :toolshare_users
  end
end
