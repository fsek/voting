# frozen_string_literal: true

require 'rails_helper'
RSpec.describe('Handle users', type: :request) do
  let(:admin) { create(:user, role: :admin) }

  it 'requires sign in' do
    get(admin_users_path)
    expect(response).to redirect_to(new_user_session_path)
    sign_in(create(:user, role: :user))
    get(admin_users_path)
    expect(response).to redirect_to(root_path)
  end

  it 'shows all users' do
    create_list(:user, 5)
    sign_in(admin)
    get(admin_users_path)
    expect(response).to have_http_status(200)
  end

  describe 'edit and update' do
    it 'valid parameers' do
      user = create(:user, firstname: 'Hilbert', lastname: 'Älg',
                           card_number: '1234-1234-1234-1234',
                           role: :user)
      attributes = { firstname: 'Helge', lastname: 'Älge',
                     card_number: '4321-4321-4321-4321',
                     role: :chairman }
      sign_in(admin)
      get(edit_admin_user_path(user))
      expect(response).to have_http_status(200)

      patch(admin_user_path(user), params: { user: attributes })
      expect(response).to redirect_to(edit_admin_user_path(user))
      user.reload

      expect(user.firstname).to eq('Helge')
      expect(user.lastname).to eq('Älge')
      expect(user.card_number).to eq('4321-4321-4321-4321')
      expect(user.chairman?).to be_truthy
    end

    it 'invalid parameters' do
      sign_in(admin)
      user = create(:user, firstname: 'Hilbert',
                           card_number: '1234-1234-1234-1234')
      attributes = { card_number: 'wrong-format' }

      patch(admin_user_path(user),
            params: { user: attributes })
      user.reload

      expect(response).to have_http_status(422)
      expect(user.firstname).to eq('Hilbert')
    end
  end

  it 'destroys user' do
    sign_in(admin)
    user = create(:user)
    expect do
      delete(admin_user_path(user))
    end.to change(User, :count).by(-1)
    expect(response).to redirect_to(admin_users_path)
  end
end
