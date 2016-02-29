class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.references :auditable, polymorphic: true, index: true
      t.references :user, index: true, foreign_key: true
      t.references :updater, index: true
      t.references :vote, index: true, foreign_key: true
      t.json :audited_changes, default: {}, null: false
      t.string :action

      t.timestamps null: false
    end
  end
end
