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

ActiveRecord::Schema.define(version: 2020_07_11_004749) do

  create_table "change_schedules", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "user_id"
    t.date "beforeDate"
    t.date "afterDate"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exams", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.date "examDate"
    t.integer "position"
    t.boolean "complete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.string "title"
    t.string "CoNum"
    t.string "teacher"
    t.string "semester"
    t.integer "position"
    t.integer "grade", default: 1
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "semester_periods", force: :cascade do |t|
    t.integer "user_id"
    t.integer "grade"
    t.date "fh_semester_f"
    t.date "fh_semester_s"
    t.date "late_semester_f"
    t.date "late_semester_s"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_schedule_relations", force: :cascade do |t|
    t.integer "schedule_id"
    t.integer "user_id"
    t.integer "reges_grade"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_tasks", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.date "taskDate"
    t.integer "position"
    t.boolean "complete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "key"
    t.string "session"
    t.integer "maxAge"
    t.integer "grade", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
