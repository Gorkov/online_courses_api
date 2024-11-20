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

ActiveRecord::Schema[7.1].define(version: 2024_11_18_114305) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "author_competencies", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "competency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.index ["author_id", "competency_id"], name: "index_author_competencies_on_author_id_and_competency_id", unique: true
    t.index ["author_id"], name: "index_author_competencies_on_author_id"
    t.index ["competency_id"], name: "index_author_competencies_on_competency_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "competencies", force: :cascade do |t|
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "course_competencies", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "competency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.index ["competency_id"], name: "index_course_competencies_on_competency_id"
    t.index ["course_id", "competency_id"], name: "index_course_competencies_on_course_id_and_competency_id", unique: true
    t.index ["course_id"], name: "index_course_competencies_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["author_id"], name: "index_courses_on_author_id"
  end

  add_foreign_key "author_competencies", "authors"
  add_foreign_key "author_competencies", "competencies"
  add_foreign_key "course_competencies", "competencies"
  add_foreign_key "course_competencies", "courses"
  add_foreign_key "courses", "authors"
end
