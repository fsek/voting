class CreateAdjustments < ActiveRecord::Migration
  def change
    create_table :adjustments do |t|
      t.references :agenda, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :presence, null: false, default: false

      t.timestamps null: false
    end
  end
end
