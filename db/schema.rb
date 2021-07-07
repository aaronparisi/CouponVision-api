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

ActiveRecord::Schema.define(version: 2021_07_07_042324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "min_coupon_value"
    t.decimal "max_coupon_value"
    t.integer "num_products"
    t.date "earliest_activation_date"
    t.date "latest_activation_date"
    t.integer "max_activation_days"
  end

  create_table "coupons", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "savings"
    t.decimal "cash_value"
    t.date "expiration_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "store_id"
    t.date "activation_date"
    t.index ["product_id"], name: "index_coupons_on_product_id"
    t.index ["store_id"], name: "index_coupons_on_store_id"
  end

  create_table "grocer_brands", force: :cascade do |t|
    t.bigint "grocer_id", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_grocer_brands_on_brand_id"
    t.index ["grocer_id"], name: "index_grocer_brands_on_grocer_id"
  end

  create_table "grocers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "num_brands"
    t.integer "num_stores"
    t.integer "max_num_coupons"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "grocer_id"
    t.integer "num_coupons"
    t.index ["grocer_id"], name: "index_stores_on_grocer_id"
  end

  add_foreign_key "coupons", "products"
  add_foreign_key "coupons", "stores"
  add_foreign_key "grocer_brands", "brands"
  add_foreign_key "grocer_brands", "grocers"
  add_foreign_key "products", "brands"
  add_foreign_key "stores", "grocers"
end
