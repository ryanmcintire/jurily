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

ActiveRecord::Schema.define(version: 20170131061717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "question_id"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "bar_admissions", force: :cascade do |t|
    t.integer  "user_detail_id"
    t.date     "date_admitted"
    t.integer  "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "jurisdiction"
    t.string   "bar_number"
  end

  add_index "bar_admissions", ["user_detail_id"], name: "index_bar_admissions_on_user_detail_id", using: :btree

  create_table "filters", force: :cascade do |t|
    t.text     "jurisdictions"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "filters", ["user_id"], name: "index_filters_on_user_id", using: :btree

  create_table "lawschool_details", force: :cascade do |t|
    t.string   "school_name"
    t.boolean  "currently_attending"
    t.integer  "user_detail_id"
    t.string   "year_graduated"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "lawschool_details", ["user_detail_id"], name: "index_lawschool_details_on_user_detail_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "title"
    t.string   "body"
    t.integer  "user_id"
    t.integer  "jurisdiction"
    t.integer  "views"
  end

  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "questions_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "question_id"
  end

  add_index "questions_tags", ["question_id"], name: "index_questions_tags_on_question_id", using: :btree
  add_index "questions_tags", ["tag_id"], name: "index_questions_tags_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_contact_infos", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_detail_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "state"
    t.string   "zipcode"
    t.string   "city"
  end

  add_index "user_contact_infos", ["user_detail_id"], name: "index_user_contact_infos_on_user_detail_id", using: :btree

  create_table "user_details", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_contact_info_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "user_id"
    t.string   "organization"
    t.string   "title"
    t.string   "website_url"
    t.string   "linkedin_url"
  end

  add_index "user_details", ["user_contact_info_id"], name: "index_user_details_on_user_contact_info_id", using: :btree
  add_index "user_details", ["user_id"], name: "index_user_details_on_user_id", using: :btree

  create_table "user_employments", force: :cascade do |t|
    t.string   "title"
    t.string   "organization"
    t.string   "organization_website"
    t.integer  "user_detail_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "user_employments", ["user_detail_id"], name: "index_user_employments_on_user_detail_id", using: :btree

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
    t.integer  "user_detail_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "filter_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["filter_id"], name: "index_users_on_filter_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_detail_id"], name: "index_users_on_user_detail_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "value"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id", using: :btree

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "bar_admissions", "user_details"
  add_foreign_key "filters", "users"
  add_foreign_key "lawschool_details", "user_details"
  add_foreign_key "questions", "users"
  add_foreign_key "user_contact_infos", "user_details"
  add_foreign_key "user_details", "user_contact_infos"
  add_foreign_key "user_details", "users"
  add_foreign_key "user_employments", "user_details"
  add_foreign_key "users", "user_details"
  add_foreign_key "votes", "users"
end
