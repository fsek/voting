class CreateVoteOptions < ActiveRecord::Migration
  def change
    create_table :vote_options do |t|
      t.string :title
      t.integer :count, :default => 0
      t.references :vote, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
