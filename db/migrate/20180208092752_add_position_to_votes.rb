class AddPositionToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column(:votes, :position, :integer)
  end
end
