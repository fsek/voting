class VotePostOnlyVotesOnce < ActiveRecord::Migration[5.2]
  def change
    add_index(:vote_posts, [:user_id, :vote_id], unique: true, where: 'deleted_at IS NULL')
  end
end
