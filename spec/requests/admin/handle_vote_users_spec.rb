# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle vote users', type: :request) do
  let(:secretary) { create(:user, role: :secretary) }

  it 'requires sign in' do
    get(admin_vote_users_path)
    expect(response).to redirect_to(new_user_session_path)
    sign_in(create(:user, role: :user))
    get(admin_vote_users_path)
    expect(response).to redirect_to(root_path)
  end

  it 'views all users' do
    create_list(:user, 5)
    sign_in(secretary)

    get(admin_vote_users_path)
    expect(response).to have_http_status(200)
  end

  it 'shows single user' do
    sign_in(secretary)
    get(admin_vote_user_path(create(:user)))
    expect(response).to have_http_status(200)
  end
end
