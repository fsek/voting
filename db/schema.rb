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

ActiveRecord::Schema.define(version: 20160405124908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjustments", force: :cascade do |t|
    t.integer  "agenda_id"
    t.integer  "user_id"
    t.boolean  "presence",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "deleted_at"
    t.integer  "row_order"
  end

  add_index "adjustments", ["agenda_id"], name: "index_adjustments_on_agenda_id", using: :btree
  add_index "adjustments", ["deleted_at"], name: "index_adjustments_on_deleted_at", using: :btree
  add_index "adjustments", ["user_id"], name: "index_adjustments_on_user_id", using: :btree

  create_table "agendas", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "index",       default: 1
    t.string   "sort_index"
    t.string   "title"
    t.string   "status",      default: "future", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "deleted_at"
    t.text     "description"
    t.string   "short"
  end

  add_index "agendas", ["deleted_at"], name: "index_agendas_on_deleted_at", using: :btree
  add_index "agendas", ["parent_id"], name: "index_agendas_on_parent_id", using: :btree

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.integer  "updater_id"
    t.integer  "vote_id"
    t.json     "audited_changes", default: {}, null: false
    t.string   "action"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "audits", ["auditable_type", "auditable_id"], name: "index_audits_on_auditable_type_and_auditable_id", using: :btree
  add_index "audits", ["updater_id"], name: "index_audits_on_updater_id", using: :btree
  add_index "audits", ["user_id"], name: "index_audits_on_user_id", using: :btree
  add_index "audits", ["vote_id"], name: "index_audits_on_vote_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "contacts", ["slug"], name: "index_contacts_on_slug", using: :btree

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
    t.integer  "agenda_id"
  end

  add_index "documents", ["agenda_id"], name: "index_documents_on_agenda_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

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
  end

  add_index "news", ["user_id"], name: "index_news_on_user_id", using: :btree

  create_table "notices", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description"
    t.boolean  "public"
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
    t.string   "card_number"
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
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
    t.integer  "user_id"
    t.integer  "selected",   default: 0, null: false
  end

  add_index "vote_posts", ["deleted_at"], name: "index_vote_posts_on_deleted_at", using: :btree
  add_index "vote_posts", ["user_id"], name: "index_vote_posts_on_user_id", using: :btree
  add_index "vote_posts", ["vote_id"], name: "index_vote_posts_on_vote_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "deleted_at"
    t.integer  "choices",       default: 1
    t.integer  "agenda_id"
    t.string   "status",        default: "future", null: false
    t.integer  "present_users", default: 0,        null: false
  end

  add_index "votes", ["agenda_id"], name: "index_votes_on_agenda_id", using: :btree
  add_index "votes", ["deleted_at"], name: "index_votes_on_deleted_at", using: :btree

  add_foreign_key "adjustments", "agendas"
  add_foreign_key "adjustments", "users"
  add_foreign_key "audits", "users"
  add_foreign_key "audits", "votes"
  add_foreign_key "documents", "agendas"
  add_foreign_key "vote_options", "votes"
  add_foreign_key "vote_posts", "users"
  add_foreign_key "vote_posts", "votes"
  add_foreign_key "votes", "agendas"
end
