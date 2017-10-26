class RemoveNotices < ActiveRecord::Migration[4.2]
  def change
    drop_table :notices do |t|
      t.string   "title", limit: 255
      t.text     "description"
      t.boolean  "public"
      t.integer  "sort"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
