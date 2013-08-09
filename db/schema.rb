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

ActiveRecord::Schema.define(version: 20130805170505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id",   null: false
    t.string   "addressable_type", null: false
    t.string   "type"
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

  create_table "blocks", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.integer  "human_client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", force: true do |t|
    t.integer  "entitieable_id",   null: false
    t.string   "entitieable_type", null: false
    t.string   "title"
    t.string   "initials"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["entitieable_id", "entitieable_type"], name: "index_entities_on_entitieable_id_and_entitieable_type", using: :btree

  create_table "properties", force: true do |t|
    t.integer  "human_property_id"
    t.integer  "block_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["block_id"], name: "index_properties_on_block_id", using: :btree
  add_index "properties", ["client_id"], name: "index_properties_on_client_id", using: :btree

end
