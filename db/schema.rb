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

ActiveRecord::Schema[7.0].define(version: 2023_03_29_162542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "postal_code"
    t.string "state"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "banks", force: :cascade do |t|
    t.string "card_number"
    t.string "card_expire"
    t.string "card_type"
    t.string "currency"
    t.string "iban"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_banks_on_user_id"
  end

  create_table "dummy_json_user_responses", force: :cascade do |t|
    t.bigint "user_id"
    t.jsonb "data"
    t.string "status", default: "pending"
    t.integer "external_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_reference"], name: "index_dummy_json_user_responses_on_external_reference", unique: true
    t.index ["status"], name: "index_dummy_json_user_responses_on_status"
    t.index ["user_id"], name: "index_dummy_json_user_responses_on_user_id", unique: true
  end

  create_table "occupations", force: :cascade do |t|
    t.string "company_name"
    t.string "title"
    t.string "department"
    t.string "address"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "postal_code"
    t.string "state"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_occupations_on_company_name", unique: true
    t.index ["user_id"], name: "index_occupations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "maiden_name"
    t.string "email"
    t.integer "age"
    t.string "gender"
    t.string "phone"
    t.string "username"
    t.string "password"
    t.date "birth_date"
    t.string "image"
    t.string "blood_group"
    t.integer "height"
    t.float "weight"
    t.string "eye_color"
    t.string "hair_color"
    t.string "hair_type"
    t.string "university"
    t.string "domain"
    t.string "mac_address"
    t.string "ip"
    t.string "ein"
    t.string "ssn"
    t.string "user_agent"
    t.string "status", default: "registered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["maiden_name"], name: "index_users_on_maiden_name"
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "banks", "users"
  add_foreign_key "dummy_json_user_responses", "users"
  add_foreign_key "occupations", "users"
end
