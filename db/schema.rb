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

ActiveRecord::Schema.define(version: 2018_02_02_102049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "adjustments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.boolean "presence", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "position"
    t.bigint "sub_item_id"
    t.index ["deleted_at"], name: "index_adjustments_on_deleted_at"
    t.index ["sub_item_id"], name: "index_adjustments_on_sub_item_id"
    t.index ["user_id"], name: "index_adjustments_on_user_id"
  end

  create_table "agendas", id: :serial, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "index", default: 1
    t.string "sort_index"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "short"
    t.integer "status", default: 0, null: false
    t.index ["deleted_at"], name: "index_agendas_on_deleted_at"
    t.index ["parent_id"], name: "index_agendas_on_parent_id"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "user_id"
    t.integer "updater_id"
    t.integer "vote_id"
    t.json "audited_changes", default: {}, null: false
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable_type_and_auditable_id"
    t.index ["updater_id"], name: "index_audits_on_updater_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
    t.index ["vote_id"], name: "index_audits_on_vote_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "title", null: false
    t.integer "type", default: 0, null: false
    t.integer "multiplicity", default: 0, null: false
    t.integer "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
  end

  create_table "news", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.string "url"
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "sub_items", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.bigint "item_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sub_items_on_deleted_at"
    t.index ["item_id"], name: "index_sub_items_on_item_id"
    t.index ["status"], name: "index_sub_items_on_status", unique: true, where: "((status < 0) AND (deleted_at IS NULL))"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "firstname", limit: 255, default: "", null: false
    t.string "lastname", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "deleted_at"
    t.boolean "presence", default: false, null: false
    t.string "votecode"
    t.string "card_number"
    t.integer "role", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["votecode"], name: "index_users_on_votecode", unique: true
  end

  create_table "vote_options", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "count", default: 0
    t.integer "vote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_vote_options_on_deleted_at"
    t.index ["vote_id"], name: "index_vote_options_on_vote_id"
  end

  create_table "vote_posts", id: :serial, force: :cascade do |t|
    t.integer "vote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "user_id"
    t.integer "selected", default: 0, null: false
    t.index ["deleted_at"], name: "index_vote_posts_on_deleted_at"
    t.index ["user_id"], name: "index_vote_posts_on_user_id"
    t.index ["vote_id"], name: "index_vote_posts_on_vote_id"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "choices", default: 1
    t.integer "present_users", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.bigint "sub_item_id"
    t.index ["deleted_at"], name: "index_votes_on_deleted_at"
    t.index ["status"], name: "index_votes_on_status", unique: true, where: "((status < 0) AND (deleted_at IS NULL))"
    t.index ["sub_item_id"], name: "index_votes_on_sub_item_id"
  end

  add_foreign_key "adjustments", "sub_items"
  add_foreign_key "adjustments", "users"
  add_foreign_key "audits", "users"
  add_foreign_key "audits", "votes"
  add_foreign_key "sub_items", "items"
  add_foreign_key "vote_options", "votes"
  add_foreign_key "vote_posts", "users"
  add_foreign_key "vote_posts", "votes"
  add_foreign_key "votes", "sub_items"
end
