class RemoveImageFromNews < ActiveRecord::Migration
  def change
    remove_column :news, :image, :string
  end
end
