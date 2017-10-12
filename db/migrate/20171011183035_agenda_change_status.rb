class AgendaChangeStatus < ActiveRecord::Migration[5.0]
  def change
    remove_column(:agendas, :status, :string, default: 'future', null: false)
    add_column(:agendas, :status, :integer, default: 0, null: false)
  end
end
