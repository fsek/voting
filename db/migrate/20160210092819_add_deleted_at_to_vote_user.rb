class AddDeletedAtToVoteUser < ActiveRecord::Migration
  def change
    add_column :vote_users, :deleted_at, :datetime
    add_index :vote_users, :deleted_at
  end
end
