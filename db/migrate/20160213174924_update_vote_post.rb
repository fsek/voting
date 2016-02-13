class UpdateVotePost < ActiveRecord::Migration
  def change
    remove_column :vote_posts, :votecode, :string
    add_reference :vote_posts, :user, index: true, foreign_key: true
  end
end
