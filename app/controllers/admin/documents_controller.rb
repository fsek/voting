# frozen_string_literal: true

module Admin
  class DocumentsController < Admin::BaseController
    authorize_resource(class: Item)

    def create
      @sub_item = SubItem.includes(:documents).find(params[:sub_item_id])
      @document = @sub_item.documents.build(document_params)

      if @document.save
        render(:success)
      else
        render(:error, status: 422)
      end
    end

    def edit
      @sub_item = SubItem.includes(:documents).find(params[:sub_item_id])
      @document = @sub_item.documents.find(params[:id])
    end

    def update
      @sub_item = SubItem.includes(:documents).find(params[:sub_item_id])
      @document = @sub_item.documents.find(params[:id])

      if @document.update(document_params)
        @sub_item.documents.reload
        render(:success)
      else
        render(:error, status: 422)
      end
    end

    def destroy
      sub_item = SubItem.find(params[:sub_item_id])
      sub_item.documents.find(params[:id]).destroy!

      redirect_to(edit_admin_item_sub_item_url(sub_item.item, sub_item),
                  t('.success'))
    end

    private

    def document_params
      params.require(:document).permit(:title, :position, :pdf)
    end
  end
end
