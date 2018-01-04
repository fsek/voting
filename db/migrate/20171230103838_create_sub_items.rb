class CreateSubItems < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_items do |t|
      t.string(:title)
      t.integer(:position)
      t.references(:item, foreign_key: true, index: true, null: false)
      t.integer(:status, default: 0, null: false)
      t.datetime(:deleted_at, index: true)

      t.timestamps
    end
  end
end
