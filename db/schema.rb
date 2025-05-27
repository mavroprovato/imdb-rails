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

ActiveRecord::Schema[8.0].define(version: 2025_04_08_200527) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "title_type", ["movie", "short", "tvEpisode", "tvMiniSeries", "tvMovie", "tvPilot", "tvSeries", "tvShort", "tvSpecial", "video", "videoGame"]

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "languages", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "unique_id", null: false
    t.string "name", null: false
    t.integer "birth_year"
    t.integer "death_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_id"], name: "index_people_on_unique_id", unique: true
  end

  create_table "regions", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_regions_on_code", unique: true
  end

  create_table "title_aliases", force: :cascade do |t|
    t.bigint "title_id", null: false
    t.bigint "region_id", null: false
    t.bigint "language_id", null: false
    t.integer "ordering", null: false
    t.string "name", null: false
    t.string "alias_attributes", default: "[]", null: false
    t.boolean "originalTitle", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_title_aliases_on_language_id"
    t.index ["region_id"], name: "index_title_aliases_on_region_id"
    t.index ["title_id", "name"], name: "index_title_aliases_on_title_id_and_name", unique: true
    t.index ["title_id"], name: "index_title_aliases_on_title_id"
  end

  create_table "title_genres", force: :cascade do |t|
    t.bigint "title_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_title_genres_on_genre_id"
    t.index ["title_id", "genre_id"], name: "index_title_genres_on_title_id_and_genre_id", unique: true
    t.index ["title_id"], name: "index_title_genres_on_title_id"
  end

  create_table "titles", force: :cascade do |t|
    t.string "unique_id", null: false
    t.enum "title_type", null: false, enum_type: "title_type"
    t.string "title", null: false
    t.string "original_title", null: false
    t.boolean "adult", default: false, null: false
    t.integer "start_year"
    t.integer "end_year"
    t.integer "runtime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unique_id"], name: "index_titles_on_unique_id", unique: true
  end

  add_foreign_key "title_aliases", "languages"
  add_foreign_key "title_aliases", "regions"
  add_foreign_key "title_aliases", "titles"
  add_foreign_key "title_genres", "genres"
  add_foreign_key "title_genres", "titles"
end
