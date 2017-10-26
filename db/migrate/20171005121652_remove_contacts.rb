class RemoveContacts < ActiveRecord::Migration[4.2]
  def change
    drop_table(:contacts) do |t|
      t.string   "name",       limit: 255
      t.string   "email",      limit: 255
      t.text     "text"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
  end
end
