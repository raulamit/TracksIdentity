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

ActiveRecord::Schema.define(:version => 20111210180358) do

  create_table "ref_decodes", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "constant_value", :null => false
    t.string   "display_value",  :null => false
    t.integer  "sort_order"
    t.boolean  "is_active"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "", :null => false
    t.string   "username"
    t.string   "cached_slug"
    t.boolean  "verified"
    t.string   "unconfirmed_email"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  create_table "util_contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "service"
    t.string   "identifier"
    t.boolean  "verified"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "util_emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "confirmation_token"
    t.datetime "confirmation_date"
    t.datetime "confirmation_sent_at"
    t.string   "status"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end
