# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_09_014047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "banned_ips", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coffee_brands", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "notes"
    t.index ["name"], name: "index_coffee_brands_on_name", unique: true
  end

  create_table "coffees", force: :cascade do |t|
    t.bigint "coffee_brand_id", default: 0, null: false
    t.string "name", null: false
    t.string "roast"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["coffee_brand_id", "name"], name: "index_coffees_on_coffee_brand_id_and_name", unique: true
    t.index ["coffee_brand_id"], name: "index_coffees_on_coffee_brand_id"
  end

  create_table "log_entries", force: :cascade do |t|
    t.bigint "log_id", null: false
    t.string "water"
    t.string "brew_method"
    t.string "grind_notes"
    t.text "tasting_notes"
    t.text "addl_notes"
    t.integer "coffee_grams"
    t.integer "water_grams"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "entry_date", null: false
    t.bigint "coffee_id", null: false
    t.index ["coffee_id"], name: "index_log_entries_on_coffee_id"
    t.index ["log_id", "entry_date"], name: "index_log_entries_on_log_id_and_entry_date", where: "(deleted_at IS NOT NULL)"
    t.index ["log_id"], name: "index_log_entries_on_log_id"
  end

  create_table "log_entry_versions", force: :cascade do |t|
    t.bigint "log_entry_id", null: false
    t.string "water"
    t.string "brew_method"
    t.string "grind_notes"
    t.text "tasting_notes"
    t.text "addl_notes"
    t.integer "coffee_grams"
    t.integer "water_grams"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "coffee_id", null: false
    t.index ["log_entry_id"], name: "index_log_entry_versions_on_log_entry_id"
  end

  create_table "login_attempts", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.integer "attempts", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["slug"], name: "index_logs_on_slug", unique: true
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name"
    t.boolean "admin", default: false, null: false
    t.jsonb "preferences", default: "{}", null: false
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "coffees", "coffee_brands"
  add_foreign_key "log_entries", "coffees", on_update: :cascade, on_delete: :restrict
  add_foreign_key "log_entries", "logs"
  add_foreign_key "log_entry_versions", "coffees", on_update: :cascade, on_delete: :restrict
  add_foreign_key "log_entry_versions", "log_entries"
  add_foreign_key "logs", "users"
end
