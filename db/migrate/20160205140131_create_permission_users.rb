class CreatePermissionUsers < ActiveRecord::Migration
  def change
    create_table :permission_users do |t|
      t.references :user, null: false, index: true
      t.references :permission, null: false, index: true
      t.timestamps null: false
    end
  end
end
