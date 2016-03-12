class VoteDefaultClosed < ActiveRecord::Migration
  def change
    change_column :votes, :open, :boolean, default: false, null: false
  end
end
