class AddDeletedAtToVoteOption < ActiveRecord::Migration
  def change
    add_column :vote_options, :deleted_at, :datetime
    add_index :vote_options, :deleted_at
  end
end
