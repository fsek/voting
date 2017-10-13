class ChangeVoteStatus < ActiveRecord::Migration[5.0]
  def change
    remove_column(:votes, :status, :string, default: 'future', null: false)
    add_column(:votes, :status, :integer, default: 0, null: false)
  end
end
