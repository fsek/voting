class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :title
      t.boolean :open, :default => true
      t.timestamps null: false
    end
  end
end
