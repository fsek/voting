class AddTextsToAgenda < ActiveRecord::Migration
  def change
    add_column :agendas, :description, :text
    add_column :agendas, :short, :string
  end
end
