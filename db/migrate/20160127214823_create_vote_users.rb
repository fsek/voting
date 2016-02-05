class CreateVoteUsers < ActiveRecord::Migration
  def change
    create_table :vote_users do |t|
      t.string :name
      t.string :votecode
      t.boolean :present, :default => true

      t.timestamps null: false
    end
  end
end
