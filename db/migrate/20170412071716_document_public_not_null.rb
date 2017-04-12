class DocumentPublicNotNull < ActiveRecord::Migration
  def up
    change_column(:documents, :public, :boolean, null: false, default: true)
  end

  def down
    puts 'Cannot reverse change_column'
  end
end
