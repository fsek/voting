class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column(:users, :role, :integer, null: false, default: 0)
  end
end
