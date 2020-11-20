# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_18_034100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_products_joins", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_categories_products_joins_on_category_id"
    t.index ["product_id"], name: "index_categories_products_joins_on_product_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orderitems", force: :cascade do |t|
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "order_id"
    t.bigint "product_id"
    t.index ["order_id"], name: "index_orderitems_on_order_id"
    t.index ["product_id"], name: "index_orderitems_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "status"
    t.string "name"
    t.string "email"
    t.string "address"
    t.string "credit_card_number"
    t.string "cvv"
    t.string "expiration_date"
    t.string "zip_code"
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "price"
    t.string "photo_url"
    t.integer "stock"
    t.bigint "merchant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "review"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end
end
