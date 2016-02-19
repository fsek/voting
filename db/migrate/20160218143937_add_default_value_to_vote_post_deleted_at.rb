class AddDefaultValueToVotePostDeletedAt < ActiveRecord::Migration
  def change
    change_column :vote_options, :deleted_at, :datetime, default: nil
  end
end
