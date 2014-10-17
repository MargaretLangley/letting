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

ActiveRecord::Schema.define(version: 20140930053829) do

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
    t.string   "road",             null: false
    t.string   "district"
    t.string   "town"
    t.string   "county",           null: false
    t.string   "postcode"
    t.string   "nation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "agents", force: true do |t|
    t.boolean  "authorized",  default: false, null: false
    t.integer  "property_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["property_id"], name: "index_agents_on_property_id", using: :btree

  create_table "charged_ins", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", force: true do |t|
    t.string   "charge_type",                                           null: false
    t.integer  "cycle_id",                                              null: false
    t.integer  "charged_in_id",                                         null: false
    t.boolean  "dormant",                               default: false, null: false
    t.decimal  "amount",        precision: 8, scale: 2,                 null: false
    t.date     "start_date",                                            null: false
    t.date     "end_date",                                              null: false
    t.integer  "account_id",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["account_id"], name: "index_charges_on_account_id", using: :btree
  add_index "charges", ["charged_in_id"], name: "index_charges_on_charged_in_id", using: :btree
  add_index "charges", ["cycle_id"], name: "index_charges_on_cycle_id", using: :btree

  create_table "clients", force: true do |t|
    t.integer  "human_ref",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", force: true do |t|
    t.integer  "account_id",                         null: false
    t.integer  "charge_id",                          null: false
    t.integer  "payment_id",                         null: false
    t.datetime "on_date",                            null: false
    t.decimal  "amount",     precision: 8, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["account_id"], name: "index_credits_on_account_id", using: :btree
  add_index "credits", ["charge_id"], name: "index_credits_on_charge_id", using: :btree
  add_index "credits", ["payment_id"], name: "index_credits_on_payment_id", using: :btree

  create_table "cycle_charged_ins", force: true do |t|
    t.integer  "cycle_id",      null: false
    t.integer  "charged_in_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cycle_charged_ins", ["charged_in_id"], name: "index_cycle_charged_ins_on_charged_in_id", using: :btree
  add_index "cycle_charged_ins", ["cycle_id"], name: "index_cycle_charged_ins_on_cycle_id", using: :btree

  create_table "cycles", force: true do |t|
    t.string   "name",       null: false
    t.integer  "order",      null: false
    t.string   "cycle_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debits", force: true do |t|
    t.integer  "account_id",                           null: false
    t.integer  "charge_id",                            null: false
    t.datetime "on_date",                              null: false
    t.date     "period_first",                         null: false
    t.date     "period_last",                          null: false
    t.decimal  "amount",       precision: 8, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debits", ["account_id"], name: "index_debits_on_account_id", using: :btree
  add_index "debits", ["charge_id", "on_date"], name: "index_debits_on_charge_id_and_on_date", unique: true, using: :btree

  create_table "due_ons", force: true do |t|
    t.integer  "day",        null: false
    t.integer  "month",      null: false
    t.integer  "year"
    t.integer  "cycle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "due_ons", ["cycle_id"], name: "index_due_ons_on_cycle_id", using: :btree

  create_table "entities", force: true do |t|
    t.integer  "entitieable_id",   null: false
    t.string   "entitieable_type", null: false
    t.string   "title"
    t.string   "initials"
    t.string   "name",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["entitieable_id", "entitieable_type"], name: "index_entities_on_entitieable_id_and_entitieable_type", using: :btree

  create_table "invoices", force: true do |t|
    t.integer  "invoicing_id"
    t.text     "billing_address",                          null: false
    t.integer  "property_ref",                             null: false
    t.date     "invoice_date",                             null: false
    t.text     "property_address",                         null: false
    t.decimal  "total_arrears",    precision: 8, scale: 2, null: false
    t.text     "client_address",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["invoicing_id"], name: "index_invoices_on_invoicing_id", using: :btree

  create_table "invoicings", force: true do |t|
    t.string   "property_range", null: false
    t.date     "period_first",   null: false
    t.date     "period_last",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", force: true do |t|
    t.integer  "invoice_id",  null: false
    t.integer  "template_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letters", ["invoice_id"], name: "index_letters_on_invoice_id", using: :btree
  add_index "letters", ["template_id"], name: "index_letters_on_template_id", using: :btree

  create_table "notices", force: true do |t|
    t.integer  "template_id"
    t.string   "instruction", null: false
    t.string   "fill_in",     null: false
    t.string   "sample",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "account_id",                         null: false
    t.datetime "booked_on",                          null: false
    t.decimal  "amount",     precision: 8, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["account_id"], name: "index_payments_on_account_id", using: :btree

  create_table "products", force: true do |t|
    t.integer  "invoice_id",   null: false
    t.string   "charge_type",  null: false
    t.date     "date_due",     null: false
    t.decimal  "amount",       null: false
    t.date     "period_first"
    t.date     "period_last"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["invoice_id"], name: "index_products_on_invoice_id", using: :btree

  create_table "properties", force: true do |t|
    t.integer  "human_ref",  null: false
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["client_id"], name: "index_properties_on_client_id", using: :btree

  create_table "search_suggestions", force: true do |t|
    t.string   "term",       null: false
    t.integer  "popularity", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settlements", force: true do |t|
    t.decimal  "amount",     precision: 8, scale: 2, null: false
    t.integer  "credit_id",                          null: false
    t.integer  "debit_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settlements", ["credit_id"], name: "index_settlements_on_credit_id", using: :btree
  add_index "settlements", ["debit_id"], name: "index_settlements_on_debit_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "description",  null: false
    t.string   "invoice_name", null: false
    t.string   "phone",        null: false
    t.string   "vat",          null: false
    t.string   "heading1",     null: false
    t.string   "heading2"
    t.text     "advice1"
    t.text     "advice2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "nickname",        null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.boolean  "admin",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
