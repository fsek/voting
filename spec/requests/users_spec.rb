# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('User updates account information', as: :request) do
  let(:user) { create(:user) }
  it 'shows user page' do
    sign_in(user)
    get(user_path)
    expect(response).to have_http_status(200)
  end

  it 'updates card number' do
    sign_in(user)
    get(user_path)
    expect(response).to have_http_status(200)
  end

  it 'shows account page' do
    sign_in(user)
    get(account_user_path)
    expect(response).to have_http_status(200)
  end

  describe 'updates account' do
    it 'correct current_password' do
      user = create(:user, password: '12345678',
                           email: 'user1234@student.lu.se')
      sign_in(user)
      attributes = { user: { email: 'user1337@student.lu.se',
                             current_password: '12345678' } }

      patch(account_user_path, params: attributes)
      user.reload

      expect(response).to redirect_to(account_user_path)
      expect(user.unconfirmed_email).to eq('user1337@student.lu.se')
    end

    it 'incorrect current_password' do
      user = create(:user, password: '12345678',
                           email: 'user1234@student.lu.se')
      sign_in(user)
      attributes = { user: { email: 'user1337@student.lu.se',
                             current_password: 'wrong_wrong' } }

      patch(account_user_path, params: attributes)
      user.reload

      expect(response).to have_http_status(422)
      expect(user.unconfirmed_email).to_not eq('user1337@student.lu.se')
    end
  end

  it 'shows password page' do
    sign_in(user)
    get(password_user_path)
    expect(response).to have_http_status(200)
  end

  describe 'updates password' do
    it 'correct current_password' do
      user = create(:user, password: '12345678')
      sign_in(user)
      attributes = { user: { password: 'passpass',
                             password_confirmation: 'passpass',
                             current_password: '12345678' } }

      patch(password_user_path, params: attributes)
      user.reload

      expect(response).to redirect_to(password_user_path)
      expect(user.valid_password?('passpass')).to be_truthy
    end

    it 'incorrect current_password' do
      user = create(:user, password: '12345678')
      sign_in(user)
      attributes = { user: { password: 'passpass',
                             password_confirmation: 'passpass',
                             current_password: 'wrong_wrong' } }

      patch(password_user_path, params: attributes)
      user.reload

      expect(response).to have_http_status(422)
      expect(user.valid_password?('passpass')).to be_falsey
    end
  end
end
