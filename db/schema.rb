# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081106194210) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts_deals", :id => false, :force => true do |t|
    t.integer  "account_id"
    t.integer  "deal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "deal_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", :force => true do |t|
    t.integer  "sponsor_id"
    t.string   "description"
    t.float    "cost"
    t.integer  "snitch_id"
    t.boolean  "is_enabled",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "account_id"
    t.integer  "deal_id"
    t.integer  "disabler_id"
    t.integer  "friend_id"
    t.integer  "comment_id"
    t.boolean  "is_enabled",   :default => true
    t.boolean  "is_sponsored"
    t.boolean  "is_sponged"
    t.boolean  "is_snitched"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "account_id"
    t.float    "saldo",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "sponger_id"
    t.integer  "sponsor_id"
    t.integer  "deal_id"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
