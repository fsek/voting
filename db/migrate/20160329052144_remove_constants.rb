class RemoveConstants < ActiveRecord::Migration
  def up
    drop_table :constants
  end

  def down
    create_table 'constants', force: :cascade do |t|
      t.string 'name', limit: 255
      t.string 'value', limit: 255
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end
  end
end
