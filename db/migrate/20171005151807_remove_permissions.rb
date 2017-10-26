class RemovePermissions < ActiveRecord::Migration[4.2]
  def change
    drop_table "permission_users", force: :cascade do |t|
      t.integer  "user_id",       null: false, index: true
      t.integer  "permission_id", null: false, index: true
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
    end

    drop_table "permissions", force: :cascade do |t|
      t.string   "name",          limit: 255
      t.string   "subject_class", limit: 255
      t.string   "action",        limit: 255
      t.datetime "created_at",                null: false
      t.datetime "updated_at",                null: false
    end
  end
end
