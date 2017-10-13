class RemovePaperclip < ActiveRecord::Migration[5.0]
  def change
    remove_column(:documents, :pdf_content_type, :string)
    remove_column(:documents, :pdf_file_size, :integer)
    remove_column(:documents, :pdf_updated_at, :datetime)
    rename_column(:documents, :pdf_file_name, :pdf)
  end
end
