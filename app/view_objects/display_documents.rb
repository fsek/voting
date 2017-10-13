# frozen_string_literal: true

# Handles documents and categories in views
class DisplayDocuments
  attr_accessor :documents, :categories, :current_category, :page

  def initialize(documents:, categories:, current_category: '', page: '')
    @documents = documents
    @categories = categories
    @current_category = current_category
    @page = page
  end
end
