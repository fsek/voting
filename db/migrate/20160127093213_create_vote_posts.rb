class CreateVotePosts < ActiveRecord::Migration
  def change
    create_table :vote_posts do |t|
      t.string :votecode
      t.references :vote, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
