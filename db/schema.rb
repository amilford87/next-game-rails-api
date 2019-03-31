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

ActiveRecord::Schema.define(version: 2019_03_31_181907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", precision: 11, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities_sports", id: false, force: :cascade do |t|
    t.bigint "sport_id", null: false
    t.bigint "facility_id", null: false
  end

  create_table "games", force: :cascade do |t|
    t.date "date"
    t.time "start_time"
    t.bigint "facility_id"
    t.bigint "sport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_games_on_facility_id"
    t.index ["sport_id"], name: "index_games_on_sport_id"
  end

  create_table "games_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sports_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sport_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "facilities"
  add_foreign_key "games", "sports"
end
