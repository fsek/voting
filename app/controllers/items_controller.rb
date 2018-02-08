# frozen_string_literal: true

class ItemsController < ApplicationController
  authorize_resource

  def index
    @items = Item.includes(:sub_items).position
  end

  def show
    @item = Item.find(params[:id])
    @sub_items = @item.sub_items.includes(:votes).with_attached_documents
    @current_item = Item.current
  end
end
