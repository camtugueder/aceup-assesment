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

ActiveRecord::Schema.define(version: 2024_02_04_154319) do

  create_table "sessions", force: :cascade do |t|
    t.string "coach_hash_id", null: false
    t.string "client_hash_id", null: false
    t.datetime "start", null: false
    t.integer "duration", default: 30, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_hash_id"], name: "index_sessions_on_client_hash_id"
    t.index ["coach_hash_id", "start"], name: "index_sessions_on_coach_hash_id_and_start", unique: true
    t.index ["coach_hash_id"], name: "index_sessions_on_coach_hash_id"
    t.index ["start"], name: "index_sessions_on_start"
  end

end
