class AddPresentUsersToVote < ActiveRecord::Migration
  def change
    add_column :votes, :present_users, :integer, null: false, default: 0
  end
end
