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
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
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

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.string "title"
    t.string "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_members_on_company_id"
    t.index ["user_id"], name: "index_company_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "maiden_name"
    t.integer "age"
    t.string "gender"
    t.string "email"
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
    t.string "external_source"
    t.integer "external_reference"
    t.boolean "soft_deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "banks", "users"
  add_foreign_key "company_members", "companies"
  add_foreign_key "company_members", "users"
end
