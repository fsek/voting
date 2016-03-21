class AddAgendaToVote < ActiveRecord::Migration
  def change
    add_reference :votes, :agenda, index: true, foreign_key: true
  end
end
