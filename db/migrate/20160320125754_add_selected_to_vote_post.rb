class AddSelectedToVotePost < ActiveRecord::Migration
  def change
    add_column :vote_posts, :selected, :integer, index: true, null: false, default: 0
  end
end
