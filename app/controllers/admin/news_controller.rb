# frozen_string_literal: true

module Admin
  # Handles creation and update of news
  class NewsController < Admin::BaseController
    authorize_resource

    def index
      @news = News.order(:created_at).includes(:user)
    end

    def new
      @news = News.new
    end

    def edit
      @news = News.find(params[:id])
    end

    def create
      @news = News.new(news_params)
      @news.user = current_user
      if @news.save
        redirect_to(admin_news_index_path, notice: t('.success'))
      else
        render(:new, status: 422)
      end
    end

    def update
      @news = News.find(params[:id])
      if @news.update(news_params)
        redirect_to(admin_news_index_path, notice: t('.success'))
      else
        render(:edit, status: 422)
      end
    end

    def destroy
      News.find(params[:id]).destroy!
      redirect_to(admin_news_index_path, notice: t('.success'))
    end

    private

    def news_params
      params.require(:news).permit(:title, :content, :url)
    end
  end
end
