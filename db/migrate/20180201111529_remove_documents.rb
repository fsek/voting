class RemoveDocuments < ActiveRecord::Migration[5.2]
  def change
    drop_table :documents, id: :serial, force: :cascade do |t|
      t.string :pdf
      t.string :title
      t.integer :position
      t.references :sub_item, foreign_key: true
      t.timestamps
    end
  end
end
