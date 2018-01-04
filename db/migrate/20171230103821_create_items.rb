class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string(:title, null: false)
      t.integer(:type, default: 0, null: false)
      t.integer(:multiplicity, default: 0, null: false)
      t.integer(:position)
      t.datetime(:deleted_at, index: true)

      t.timestamps
    end
  end
end
