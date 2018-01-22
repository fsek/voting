# frozen_string_literal: true

module Admin
  # Handles items on the Agenda
  class ItemsController < BaseController
    authorize_resource

    def index
      @items = Item.position
      @vote_status_view = VoteStatusView.new
    end

    def new
      @item = Item.new
    end

    def edit
      @item = Item.includes(:sub_items).find(params[:id])
    end

    def create
      @item = Item.new(item_params)
      if ItemService.create_item(@item)
        redirect_to(edit_admin_item_path(@item), notice: t('.success'))
      else
        render(:new, status: 422)
      end
    end

    def update
      @item = Item.includes(:sub_items).find(params[:id])
      if @item.update(item_params)
        redirect_to(edit_admin_item_path(@item), notice: t('.success'))
      else
        render(:edit, status: 422)
      end
    end

    def destroy
      Item.find(params[:id]).destroy!
      redirect_to(admin_items_path, notice: t('.success'))
    end

    private

    def item_params
      params.require(:item).permit(:title, :type, :position, :multiplicity)
    end
  end
end
