class VotesUseSubItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference(:votes, :agenda, index: true, foreign_key: true)
    add_reference(:votes, :sub_item, index: true, foreign_key: true)
  end
end
