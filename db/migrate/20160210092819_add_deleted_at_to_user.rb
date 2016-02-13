class AddDeletedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_column :users, :presence, :boolean, default: false, null: false
    add_column :users, :votecode, :string

    add_index :users, :deleted_at
    add_index :users, :votecode, unique: true
  end
end
