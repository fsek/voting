class AddChoicesToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :choices, :integer, default: 1
  end
end
