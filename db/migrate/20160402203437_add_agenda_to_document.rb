class AddAgendaToDocument < ActiveRecord::Migration
  def change
    add_reference :documents, :agenda, index: true, foreign_key: true
  end
end
