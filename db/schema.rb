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

ActiveRecord::Schema.define(:version => 20100626100853) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "equipment", :force => true do |t|
    t.string   "name"
    t.string   "part_number"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "units",       :default => 0
  end

  create_table "stock_items", :force => true do |t|
    t.date     "stock_date",                     :null => false
    t.integer  "user_id",                        :null => false
    t.integer  "stock_id",                       :null => false
    t.integer  "stock_target_id"
    t.integer  "equipment_id",                   :null => false
    t.float    "quantity",                       :null => false
    t.integer  "doc_type",        :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stock_items", ["stock_id", "equipment_id"], :name => "index_stock_items_on_stock_id_and_equipment_id"

  create_table "stocks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stocks_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "stock_id"
  end

  add_index "stocks_users", ["stock_id", "user_id"], :name => "index_stocks_users_on_stock_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.datetime "last_login_at"
  end

end
