class DocumentsUseSubItems < ActiveRecord::Migration[5.1]
  def change
    remove_column(:documents, :public, :boolean, default: true, null: false)
    remove_column(:documents, :category, :string)
    remove_reference(:documents, :user, index: true)
    remove_reference(:documents, :agenda, index: true, foreign_key: true)
    add_column(:documents, :position, :integer)
    add_reference(:documents, :sub_item, foreign_key: true)
  end
end
