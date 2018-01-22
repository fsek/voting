# frozen_string_literal: true

class ItemsController < ApplicationController
  authorize_resource

  def index
    @items = Item.includes(:sub_items).position
  end

  def show
    @item = Item.includes(sub_items: :votes).find(params[:id])
    @current_item = Item.current
  end
end
