class AddSlugToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :slug, :string
    add_index :contacts, :slug
  end
end
