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

ActiveRecord::Schema.define(version: 2021_02_18_010627) do

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_employees_on_name", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  create_table "shift_availabilities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "employee_id"
    t.integer "shift_id"
    t.index ["employee_id"], name: "index_shift_availabilities_on_employee_id"
    t.index ["shift_id"], name: "index_shift_availabilities_on_shift_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "employee_id"
    t.integer "service_id"
    t.integer "week_id"
    t.index ["employee_id", "week_id", "start_time", "day"], name: "index_shifts_on_employee_id_and_week_id_and_start_time_and_day", unique: true
    t.index ["employee_id"], name: "index_shifts_on_employee_id"
    t.index ["service_id", "week_id", "start_time", "day"], name: "index_shifts_on_service_id_and_week_id_and_start_time_and_day", unique: true
    t.index ["service_id"], name: "index_shifts_on_service_id"
    t.index ["week_id"], name: "index_shifts_on_week_id"
  end

  create_table "weeks", force: :cascade do |t|
    t.integer "number", default: 7
    t.integer "year", default: 21
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["year", "number"], name: "index_weeks_on_year_and_number", unique: true
  end

  add_foreign_key "shift_availabilities", "employees"
  add_foreign_key "shift_availabilities", "shifts"
  add_foreign_key "shifts", "employees"
  add_foreign_key "shifts", "services"
  add_foreign_key "shifts", "weeks"
end
