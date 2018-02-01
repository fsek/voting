# frozen_string_literal: true

module Admin
  class DocumentsController < Admin::BaseController
    authorize_resource(class: Item)

    def create
      @sub_item = SubItem.find(params[:sub_item_id])
      begin
        @sub_item.documents.attach(document_params)
        render(:success)
      rescue
        render(:error, status: 422)
      end
    end

    def destroy
      @sub_item = SubItem.find(params[:sub_item_id])
      @sub_item.documents.find(params[:id]).purge
      render(:success)
    end

    private

    def document_params
      params.require(:sub_item).fetch(:files, [])
    end
  end
end
