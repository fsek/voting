# frozen_string_literal: true

module Admin
  # Handles items on the Agenda
  class SubItemsController < BaseController
    authorize_resource(class: Item)

    def index
      @item = Item.find(params[:item_id])
      @sub_items = @item.sub_items
    end

    def new
      @item = Item.find(params[:item_id])
      @sub_item = @item.sub_items.build
    end

    def edit
      @item = Item.find(params[:item_id])
      @sub_item = @item.sub_items.with_attached_documents.find(params[:id])
    end

    def create
      @item = Item.find(params[:item_id])
      @sub_item = @item.sub_items.build(sub_item_params)
      if @sub_item.save
        redirect_to(edit_admin_item_path(@item), notice: t('.success'))
      else
        render(:new, status: 422)
      end
    end

    def update
      @item = Item.find(params[:item_id])
      @sub_item = @item.sub_items.find(params[:id])
      if @sub_item.update(sub_item_params)
        redirect_to(edit_admin_item_path(@item), notice: t('.success'))
      else
        render(:new, status: 422)
      end
    end

    def destroy
      item = Item.find(params[:item_id])
      item.sub_items.find(params[:id]).destroy!
      redirect_to(edit_admin_item_path(item), notice: t('.success'))
    end

    private

    def sub_item_params
      params.require(:sub_item).permit(:title, :position)
    end
  end
end
