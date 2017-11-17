# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Admin::VoteUsersController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, :vote_user)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'renders all vote users' do
      create(:user, firstname: 'First')
      create(:user, firstname: 'Second')
      create(:user, firstname: 'Third')

      get(:index)
      response.should have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'assigns given user as @user' do
      user = create(:user)

      get(:show, params: { id: user.to_param })
      response.should have_http_status(200)
    end
  end
end
