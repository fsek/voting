class RemoveMenus < ActiveRecord::Migration
  def change
    drop_table "menus" do |t|
      t.string   "location", limit: 255
      t.integer  "index"
      t.string   "link",       limit: 255
      t.string   "name",       limit: 255
      t.boolean  "visible"
      t.boolean  "turbolinks", default: true
      t.boolean  "blank_p"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
