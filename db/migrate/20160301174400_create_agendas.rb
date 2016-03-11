class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
      t.references :parent, index: true
      t.integer :index, default: 1
      t.string :sort_index
      t.string :title
      t.string :status, null: false, default: 'future'

      t.timestamps null: false
    end
  end
end
