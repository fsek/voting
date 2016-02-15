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

ActiveRecord::Schema.define(version: 20160218143937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "constants", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "pdf_file_name",    limit: 255
    t.string   "pdf_content_type", limit: 255
    t.integer  "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.string   "title",            limit: 255
    t.boolean  "public"
    t.string   "category",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question",      limit: 255
    t.text     "answer"
    t.integer  "sorting_index"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",      limit: 255
  end

  add_index "faqs", ["category"], name: "index_faqs_on_category", using: :btree

  create_table "menus", force: :cascade do |t|
    t.string   "location",   limit: 255
    t.integer  "index"
    t.string   "link",       limit: 255
    t.string   "name",       limit: 255
    t.boolean  "visible"
    t.boolean  "turbolinks",             default: true
    t.boolean  "blank_p"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "url"
    t.string   "image"
  end

  add_index "news", ["user_id"], name: "index_news_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.boolean  "public"
    t.date     "d_publish"
    t.date     "d_remove"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permission_users", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "permission_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "permission_users", ["permission_id"], name: "index_permission_users_on_permission_id", using: :btree
  add_index "permission_users", ["user_id"], name: "index_permission_users_on_user_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "subject_class", limit: 255
    t.string   "action",        limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "firstname",              limit: 255, default: "",    null: false
    t.string   "lastname",               limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "deleted_at"
    t.boolean  "presence",                           default: false, null: false
    t.string   "votecode"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["votecode"], name: "index_users_on_votecode", unique: true, using: :btree

  create_table "vote_options", force: :cascade do |t|
    t.string   "title"
    t.integer  "count",      default: 0
    t.integer  "vote_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "vote_options", ["deleted_at"], name: "index_vote_options_on_deleted_at", using: :btree
  add_index "vote_options", ["vote_id"], name: "index_vote_options_on_vote_id", using: :btree

  create_table "vote_posts", force: :cascade do |t|
    t.integer  "vote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer  "user_id"
  end

  add_index "vote_posts", ["deleted_at"], name: "index_vote_posts_on_deleted_at", using: :btree
  add_index "vote_posts", ["user_id"], name: "index_vote_posts_on_user_id", using: :btree
  add_index "vote_posts", ["vote_id"], name: "index_vote_posts_on_vote_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.string   "title"
    t.boolean  "open",       default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
  end

  add_index "votes", ["deleted_at"], name: "index_votes_on_deleted_at", using: :btree

  add_foreign_key "vote_options", "votes"
  add_foreign_key "vote_posts", "users"
  add_foreign_key "vote_posts", "votes"
end
