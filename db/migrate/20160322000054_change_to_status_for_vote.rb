class ChangeToStatusForVote < ActiveRecord::Migration
  def change
    remove_column :votes, :open, :boolean
    add_column :votes, :status, :string, null: false, default: 'future'
  end
end
