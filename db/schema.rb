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

ActiveRecord::Schema.define(version: 2021_11_07_133855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banned_ips", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.bigint "log_id", null: false
    t.string "coffee", null: false
    t.string "water"
    t.string "brew_method"
    t.string "grind"
    t.text "tasting"
    t.text "addl_notes"
    t.integer "coffee_grams"
    t.integer "water_grams"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["log_id", "created_at"], name: "index_log_entries_on_log_id_and_created_at", where: "(deleted_at IS NOT NULL)"
    t.index ["log_id"], name: "index_log_entries_on_log_id"
  end

  create_table "log_entry_versions", force: :cascade do |t|
    t.bigint "log_entry_id", null: false
    t.string "coffee"
    t.string "water"
    t.string "brew_method"
    t.string "grind"
    t.text "tasting"
    t.text "addl_notes"
    t.integer "coffee_grams"
    t.integer "water_grams"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["log_entry_id"], name: "index_log_entry_versions_on_log_entry_id"
  end

  create_table "login_attempts", primary_key: "ip_address", id: :string, force: :cascade do |t|
    t.integer "attempts", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "logs", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "owned_by_user_id", null: false
    t.index ["owned_by_user_id"], name: "index_logs_on_owned_by_user_id"
    t.index ["slug"], name: "index_logs_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username"
  end

  add_foreign_key "log_entries", "logs"
  add_foreign_key "log_entry_versions", "log_entries"
  add_foreign_key "logs", "users", column: "owned_by_user_id"
end
