class VotePostsSetNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:vote_posts, :vote_id, false)
    change_column_null(:vote_posts, :user_id, false)
  end
end
