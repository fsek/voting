class AddDeletedAtToAgendaAdjustment < ActiveRecord::Migration
  def change
    add_column :agendas, :deleted_at, :datetime
    add_index :agendas, :deleted_at
    add_column :adjustments, :deleted_at, :datetime
    add_index :adjustments, :deleted_at
  end
end
