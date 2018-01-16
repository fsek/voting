# frozen_string_literal: true

module Admin
  class DocumentsController < Admin::BaseController
    load_and_authorize_resource

    def edit
      @document = Document.find(params[:id])
    end

    def new
      @document = Document.new
    end

    def create
      @sub_item = SubItem.find(params[:sub_item_id])
      @document = @sub_item.documents.build(document_params)

      if @document.save
        redirect_to(edit_admin_document_path(@document), notice: t('.success'))
      else
        render(:new, status: 422)
      end
    end

    def update
      @document = Document.find(params[:id])

      if @document.update(document_params)
        redirect_to(edit_admin_document_path(@document), notice: t('.success'))
      else
        render(:edit, status: 422)
      end
    end

    def destroy
      Document.find(params[:id]).destroy!
      redirect_back(fallback_path: admin_items_path, notice: t('.success'))
    end

    private

    def document_params
      params.require(:document).permit(:title, :pdf)
    end
  end
end
