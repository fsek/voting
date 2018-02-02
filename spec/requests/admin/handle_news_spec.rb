# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Handle news', type: :request do
  let(:secretary) { create(:user, role: :secretary) }

  it 'requires sign in' do
    get(admin_news_index_path)
    expect(response).to redirect_to(new_user_session_path)
    sign_in(create(:user, role: :user))
    get(admin_news_index_path)
    expect(response).to redirect_to(root_path)
  end

  it 'shows all news' do
    create_list(:news, 3)
    sign_in(secretary)
    get(admin_news_index_path)
    expect(response).to have_http_status(200)
  end

  describe 'create new' do
    it 'valid attributes' do
      sign_in(secretary)
      attributes = { title: 'Wohoo', content: '**rosta rosta roosta**' }
      get(new_admin_news_path)
      expect(response).to have_http_status(200)

      expect do
        post(admin_news_index_path, params: { news: attributes })
      end.to change(News, :count).by(1)

      expect(response).to redirect_to(admin_news_index_path)
      expect(News.last.user).to eq(secretary)
    end

    it 'invalid attributes' do
      sign_in(secretary)
      attributes = { content: '**rosta rosta roosta**' }
      expect do
        post(admin_news_index_path, params: { news: attributes })
      end.to change(News, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end

  describe 'update' do
    it 'valid attributes' do
      news = create(:news, user: secretary, title: 'Nope')
      sign_in(secretary)
      attributes = { title: 'Wohoo' }
      get(edit_admin_news_path(news))
      expect(response).to have_http_status(200)

      patch(admin_news_path(news), params: { news: attributes })
      expect(response).to redirect_to(admin_news_index_path)
      news.reload
      expect(news.title).to eq('Wohoo')
    end

    it 'invalid attributes' do
      news = create(:news, user: secretary, title: 'Wohoo')
      sign_in(secretary)
      attributes = { title: nil }

      patch(admin_news_path(news), params: { news: attributes })
      expect(response).to have_http_status(422)
      news.reload
      expect(news.title).to eq('Wohoo')
    end
  end

  it 'destroys news' do
    sign_in(secretary)
    news = create(:news)
    expect do
      delete(admin_news_path(news))
    end.to change(News, :count).by(-1)
    expect(response).to redirect_to(admin_news_index_path)
  end
end
