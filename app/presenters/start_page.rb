# frozen_string_literal: true

class StartPage
  attr_accessor :items, :news

  def initialize
    @items = Item.includes(:sub_items).position || []
    @news = News.order(created_at: :desc).limit(5).includes(:user) || []
  end
end
