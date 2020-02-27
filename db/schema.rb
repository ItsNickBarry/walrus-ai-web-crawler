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

ActiveRecord::Schema.define(version: 2020_02_27_022135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "web_page_relationships", force: :cascade do |t|
    t.integer "parent_id", null: false
    t.integer "child_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id", "child_id"], name: "index_web_page_relationships_on_parent_id_and_child_id", unique: true
  end

  create_table "web_pages", force: :cascade do |t|
    t.string "uri", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", null: false
    t.datetime "crawled_at"
    t.index ["uri"], name: "index_web_pages_on_uri", unique: true
  end

end
