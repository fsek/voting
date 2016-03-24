require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other) { create(:user) }

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  allow_user_to :manage, User

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      get(:show, id: other.to_param)
      assigns(:user).should eq(other)
    end
  end

  describe 'GET #edit' do
    it 'should render edit page' do
      get(:edit)
      response.code.should eq('200')
    end
  end

  describe 'PATCH #update_account' do
    it 'updates account' do
      patch :update_account, user: { email: 'tfy16hal@student.lu.se',
                                     current_password: '12345678' }
      user.reload
      user.unconfirmed_email.should eq('tfy16hal@student.lu.se')
    end
  end

  describe 'PATCH #update_password' do
    it 'updates password' do
      patch :update_password, user: { password: 'testatesta',
                                      password_confirmation: 'testatesta',
                                      current_password: '12345678' }
      user.reload
      user.valid_password?('testatesta').should be_truthy
    end
  end

  describe 'PATCH #update' do
    it 'set card_number' do
      user = create(:user, card_number: nil)
      allow(controller).to receive(:current_user) { user }

      patch(:update, user: { card_number: '6122-6122-6122-6122' })

      user.reload
      response.status.should eq(200)
      user.card_number.should eq('6122-6122-6122-6122')
    end
  end
end
