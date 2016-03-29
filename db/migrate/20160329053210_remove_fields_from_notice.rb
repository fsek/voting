class RemoveFieldsFromNotice < ActiveRecord::Migration
  def change
    remove_column :notices, :d_publish, :date
    remove_column :notices, :d_remove, :date
  end
end
