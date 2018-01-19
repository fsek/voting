class VotesOnlyOneOpen < ActiveRecord::Migration[5.1]
  def change
    add_index(:votes, :status, unique: true, where: 'status < 0 AND deleted_at IS NULL')
  end
end
