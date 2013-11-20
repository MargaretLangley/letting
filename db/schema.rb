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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131016112247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["property_id"], name: "index_accounts_on_property_id", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id",   null: false
    t.string   "addressable_type", null: false
    t.string   "flat_no"
    t.string   "house_name"
    t.string   "road_no"
    t.string   "road"
    t.string   "district"
    t.string   "town"
    t.string   "county"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "billing_profiles", force: true do |t|
    t.boolean  "use_profile", default: false, null: false
    t.integer  "property_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "billing_profiles", ["property_id"], name: "index_billing_profiles_on_property_id", using: :btree

  create_table "blocks", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", force: true do |t|
    t.string   "charge_type",                         null: false
    t.string   "due_in",                              null: false
    t.decimal  "amount",      precision: 8, scale: 2, null: false
    t.date     "start_date",                          null: false
    t.date     "end_date",                            null: false
    t.integer  "account_id",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["account_id"], name: "index_charges_on_account_id", using: :btree

  create_table "clients", force: true do |t|
    t.integer  "human_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", force: true do |t|
    t.integer  "account_id",                                         null: false
    t.integer  "charge_id",                                          null: false
    t.integer  "payment_id",                                         null: false
    t.date     "on_date",                                            null: false
    t.integer  "debit_id"
    t.boolean  "advanced",                           default: false, null: false
    t.decimal  "amount",     precision: 8, scale: 2,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["account_id"], name: "index_credits_on_account_id", using: :btree
  add_index "credits", ["charge_id"], name: "index_credits_on_charge_id", using: :btree
  add_index "credits", ["debit_id"], name: "index_credits_on_debit_id", using: :btree
  add_index "credits", ["payment_id"], name: "index_credits_on_payment_id", using: :btree

  create_table "debit_generators", force: true do |t|
    t.string   "search_string", null: false
    t.date     "start_date",    null: false
    t.date     "end_date",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debits", force: true do |t|
    t.integer  "account_id",                                 null: false
    t.integer  "charge_id",                                  null: false
    t.date     "on_date",                                    null: false
    t.decimal  "amount",             precision: 8, scale: 2, null: false
    t.integer  "debit_generator_id",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debits", ["account_id"], name: "index_debits_on_account_id", using: :btree
  add_index "debits", ["charge_id", "on_date"], name: "index_debits_on_charge_id_and_on_date", unique: true, using: :btree
  add_index "debits", ["charge_id"], name: "index_debits_on_charge_id", using: :btree
  add_index "debits", ["debit_generator_id"], name: "index_debits_on_debit_generator_id", using: :btree

  create_table "due_ons", force: true do |t|
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.integer  "charge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "due_ons", ["charge_id"], name: "index_due_ons_on_charge_id", using: :btree

  create_table "entities", force: true do |t|
    t.string   "entity_type",      null: false
    t.integer  "entitieable_id",   null: false
    t.string   "entitieable_type", null: false
    t.string   "title"
    t.string   "initials"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["entitieable_id", "entitieable_type"], name: "index_entities_on_entitieable_id_and_entitieable_type", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "account_id",                         null: false
    t.datetime "on_date",                            null: false
    t.decimal  "amount",     precision: 8, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id", using: :btree

  create_table "properties", force: true do |t|
    t.integer  "human_ref"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["client_id"], name: "index_properties_on_client_id", using: :btree

  create_table "search_suggestions", force: true do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
