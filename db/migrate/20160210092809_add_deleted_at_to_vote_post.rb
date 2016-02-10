class AddDeletedAtToVotePost < ActiveRecord::Migration
  def change
    add_column :vote_posts, :deleted_at, :datetime
    add_index :vote_posts, :deleted_at
  end
end
