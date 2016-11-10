# encoding:UTF-8
class DocumentsController < ApplicationController
  load_permissions_and_authorize_resource

  def index
    documents = set_documents(params[:category])
    grid = initialize_grid(documents, order: 'documents.updated_at',
                                      order_direction: 'desc')

    @documents = DocumentView.new(grid: grid,
                                  categories: Document.categories,
                                  current_category: params[:category])
  end

  def show
    document = Document.find(params[:id])
    stream = open(document.view)
    file = File.open(document.pdf_file_name, 'w+b') do |f|
      stream.respond_to?(:read) ? IO.copy_stream(stream, f): f.write(stream)
      open(f)
    end

    send_file(file,
              filename: document.pdf_file_name,
              type: 'application/pdf',
              disposition: 'inline',
              x_sendfile: true)
  end

  private

  def set_documents(category)
    if current_user.try(:member?)
      filter_documents(Document.all, category)
    else
      filter_documents(Document.publik, category)
    end
  end

  def filter_documents(documents, category)
    if category.present?
      documents.where(category: category)
    else
      documents
    end
  end
end
