# frozen_string_literal: true

module Admin
  # Sets current agenda item
  class CurrentItemsController < Admin::BaseController
    authorize_resource(class: Item)

    def update
      @sub_item = SubItem.includes(:item).find(params[:id])
      @success = @sub_item.update(status: :current)
    end

    def destroy
      @sub_item = SubItem.includes(:item).find(params[:id])
      @success = @sub_item.update(status: :closed)
    end
  end
end
