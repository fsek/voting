class RemoveFaq < ActiveRecord::Migration
  def up
    drop_table :faqs
  end

  def down
    create_table 'faqs', force: :cascade do |t|
      t.string 'question', limit: 255
      t.text 'answer', limit: 65535
      t.integer 'sorting_index', limit: 4
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.string 'category', limit: 255
    end
    add_index 'faqs', ['category'], name: 'index_faqs_on_category', using: :btree
  end
end
