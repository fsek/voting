# frozen_string_literal: true

class DocumentsController < ApplicationController
  authorize_resource

  def index
    documents = Document.all.order(:title)
    documents = filter_documents(documents, params[:category], params[:page])
    @display = DisplayDocuments.new(documents: documents,
                                    categories: Document.categories,
                                    current_category: params[:category],
                                    page: params[:page])
  end

  def show
    document = Document.find(params[:id])
    if document.view
      redirect_to document.view
    else
      redirect_to documents_path, alert: t('model.document.not_found')
    end
  end

  private

  def filter_documents(documents, category, page)
    documents = documents.page(page)
    documents = documents.where(category: category) if category.present?
    documents
  end
end
