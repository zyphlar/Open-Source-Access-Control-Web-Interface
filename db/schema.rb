# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130922064241) do

  create_table "cards", :force => true do |t|
    t.string   "card_number"
    t.integer  "card_permissions"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "name"
  end

  create_table "certifications", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "door_logs", :force => true do |t|
    t.string   "key"
    t.integer  "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ipns", :force => true do |t|
    t.integer  "payment_id"
    t.text     "data"
    t.string   "txn_id"
    t.string   "txn_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "payer_business_name"
    t.string   "payer_email"
    t.string   "payer_id"
    t.string   "auth_amount"
    t.string   "payment_date"
    t.string   "payment_fee"
    t.string   "payment_gross"
    t.string   "payment_status"
    t.string   "item_name"
    t.string   "payment_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "mac_logs", :force => true do |t|
    t.string   "mac"
    t.string   "ip"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "macs", :force => true do |t|
    t.integer  "user_id"
    t.string   "mac"
    t.string   "ip"
    t.datetime "since"
    t.datetime "refreshed"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "hidden"
    t.string   "note"
  end

  add_index "macs", ["user_id"], :name => "index_macs_on_user_id"

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "created_by"
    t.decimal  "amount"
  end

  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "paypal_csvs", :force => true do |t|
    t.integer  "payment_id"
    t.text     "data"
    t.string   "date"
    t.string   "_time"
    t.string   "_time_zone"
    t.string   "_name"
    t.string   "_type"
    t.string   "_status"
    t.string   "_currency"
    t.string   "_gross"
    t.string   "_fee"
    t.string   "_net"
    t.string   "_from_email_address"
    t.string   "_to_email_address"
    t.string   "_transaction_id"
    t.string   "_counterparty_status"
    t.string   "_address_status"
    t.string   "_item_title"
    t.string   "_item_id"
    t.string   "string"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "user_certifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "certification_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "updated_by"
    t.integer  "created_by"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.integer  "member",                 :limit => 255
    t.datetime "waiver"
    t.datetime "orientation"
    t.string   "emergency_name"
    t.string   "emergency_phone"
    t.string   "emergency_email"
    t.integer  "member_level",           :limit => 255
    t.string   "payment_method"
    t.string   "phone"
    t.text     "current_skills"
    t.text     "desired_skills"
    t.boolean  "instructor"
    t.boolean  "hidden"
    t.text     "marketing_source"
    t.string   "payee"
    t.boolean  "accountant"
    t.string   "exit_reason"
    t.string   "twitter_url"
    t.string   "facebook_url"
    t.string   "github_url"
    t.string   "website_url"
    t.boolean  "email_visible"
    t.boolean  "phone_visible"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
