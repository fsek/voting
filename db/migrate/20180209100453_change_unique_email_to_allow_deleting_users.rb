class ChangeUniqueEmailToAllowDeletingUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index(:users, column: :email, unique: true)
    add_index(:users, :email, unique: true, where: 'deleted_at IS NULL')
    add_index(:users, :card_number, unique: true, where: 'deleted_at IS NULL')
  end
end
