require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  let(:user) { create(:user) }
  let(:news) { create(:news, user: user) }

  allow_user_to(:manage, :static_pages)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #about' do
    it 'renders page with status 200' do
      get(:about)
      response.status.should eq(200)
    end
  end

  describe 'GET #cookies' do
    it 'renders page with status 200' do
      get(:cookies_information)
      response.status.should eq(200)
    end
  end

  describe 'GET #index' do
    it 'not signed in, renders page with status 200' do
      get(:index)
      response.status.should eq(200)

      assigns(:start_page).class.should eq(StartPage)
    end
  end

  describe 'GET #lets_encrypt' do
    it 'renders set text' do
      token = 'awsdawsdwasdwasd6122awsdawsdawsd3737'
      ENV['LETSENCRYPT_TOKEN'] = token
      get(:lets_encrypt, key: 'aa')

      response.status.should eq(200)
      response.body.should eq(token)
    end
  end
end
