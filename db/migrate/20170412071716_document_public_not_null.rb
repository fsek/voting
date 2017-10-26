class DocumentPublicNotNull < ActiveRecord::Migration[4.2]
  def up
    change_column(:documents, :public, :boolean, null: false, default: true)
  end

  def down
    puts 'Cannot reverse change_column'
  end
end
