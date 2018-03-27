# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Static pages', type: :request) do
  it 'renders about' do
    get(about_path)
    expect(response).to have_http_status(200)
  end

  it 'renders cookies' do
    get(cookies_path)
    expect(response).to have_http_status(200)
  end

  it 'renders terms' do
    get(terms_path)
    expect(response).to have_http_status(200)
  end

  it 'renders start page' do
    create_list(:sub_item, 5)
    create_list(:news, 5)
    get(root_path)
    expect(response).to have_http_status(200)
  end
end
