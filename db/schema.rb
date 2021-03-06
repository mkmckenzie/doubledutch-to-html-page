# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160621174725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "models", force: :cascade do |t|
    t.string   "Program"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.datetime "import_time"
  end

  add_index "programs", ["user_id"], name: "index_programs_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "location"
    t.string   "session_tracks"
    t.string   "filters"
    t.string   "speaker_id"
    t.string   "link_urls"
    t.string   "session_id"
    t.integer  "program_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "deleted"
  end

  add_index "sessions", ["program_id"], name: "index_sessions_on_program_id", using: :btree

  create_table "speakers", force: :cascade do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "title"
    t.string   "company"
    t.string   "description"
    t.string   "img_url"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "linkedin"
    t.string   "session_ids"
    t.string   "attendee_id"
    t.string   "speaker_id"
    t.integer  "program_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "speakers", ["program_id"], name: "index_speakers_on_program_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "programs", "users"
  add_foreign_key "sessions", "programs"
  add_foreign_key "speakers", "programs"
end
