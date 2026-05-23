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

ActiveRecord::Schema[8.1].define(version: 2023_10_20_015042) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "banned_ips", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brew_methods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "default_brew_ratio", default: 16.6667, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coffee_brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["name"], name: "index_coffee_brands_on_name", unique: true
  end

  create_table "coffees", force: :cascade do |t|
    t.bigint "coffee_brand_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.boolean "decaf"
    t.string "name", null: false
    t.text "notes"
    t.string "origin"
    t.string "process"
    t.bigint "roast_id"
    t.datetime "updated_at", null: false
    t.index ["coffee_brand_id", "name"], name: "index_coffees_on_coffee_brand_id_and_name", unique: true
    t.index ["coffee_brand_id"], name: "index_coffees_on_coffee_brand_id"
    t.index ["roast_id"], name: "index_coffees_on_roast_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_group_id", null: false
    t.bigint "user_id", null: false
    t.index ["user_group_id"], name: "index_group_memberships_on_user_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "log_entries", force: :cascade do |t|
    t.integer "acidity"
    t.text "addl_notes"
    t.integer "bitterness"
    t.integer "body"
    t.bigint "brew_method_id", null: false
    t.integer "coffee_grams"
    t.bigint "coffee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.datetime "entry_date", precision: nil, null: false
    t.string "grind_notes"
    t.float "grind_setting"
    t.bigint "log_id", null: false
    t.integer "overall_rating"
    t.text "preparation_notes"
    t.integer "strength"
    t.text "tasting_notes"
    t.datetime "updated_at", null: false
    t.string "water"
    t.integer "water_grams"
    t.float "water_temp_in_celsius"
    t.index ["brew_method_id"], name: "index_log_entries_on_brew_method_id"
    t.index ["coffee_id"], name: "index_log_entries_on_coffee_id"
    t.index ["log_id", "entry_date"], name: "index_log_entries_on_log_id_and_entry_date", where: "(deleted_at IS NOT NULL)"
    t.index ["log_id"], name: "index_log_entries_on_log_id"
  end

  create_table "login_attempts", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.integer "attempts", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["slug"], name: "index_logs_on_slug", unique: true
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "searchable_id"
    t.string "searchable_type"
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "roasts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roasts_on_name", unique: true
  end

  create_table "signup_codes", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_group_id", null: false
    t.index ["code"], name: "index_signup_codes_on_code", unique: true
    t.index ["user_group_id"], name: "index_signup_codes_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_user_groups_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "display_name"
    t.citext "email"
    t.string "email_verification_token"
    t.datetime "email_verified_at", precision: nil
    t.datetime "last_login_at", precision: nil
    t.citext "new_email"
    t.datetime "password_changed_at", precision: nil, null: false
    t.string "password_digest"
    t.jsonb "preferences", default: "{}", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_created_at", precision: nil
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.datetime "verification_email_sent_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(email IS NOT NULL)"
    t.index ["email_verification_token"], name: "index_users_on_email_verification_token", unique: true, where: "(email_verification_token IS NOT NULL)"
    t.index ["new_email"], name: "index_users_on_new_email", unique: true, where: "(new_email IS NOT NULL)"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, where: "(reset_password_token IS NOT NULL)"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at"
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.text "object"
    t.string "whodunnit"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "coffees", "coffee_brands"
  add_foreign_key "coffees", "roasts"
  add_foreign_key "group_memberships", "user_groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "log_entries", "brew_methods"
  add_foreign_key "log_entries", "coffees", on_update: :cascade, on_delete: :restrict
  add_foreign_key "log_entries", "logs"
  add_foreign_key "logs", "users"
  add_foreign_key "signup_codes", "user_groups"
end
