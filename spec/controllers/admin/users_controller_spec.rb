require 'rails_helper'
RSpec.describe Admin::UsersController, type: :controller do
  allow_user_to :manage, :all

  describe 'GET #index' do
    it 'is successful' do
      create(:user)
      create(:user)
      create(:user)
      create(:user)
      create(:user)

      get(:index)
      response.status.should eq(200)
      assigns(:users_grid).should be_present
    end
  end

  describe 'GET #edit' do
    it 'sets users by id and renders if admin' do
      user = create(:user)

      get(:edit, params: { id: user.to_param })
      response.status.should eq(200)
      assigns(:user).should eq(user)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      user = create(:user, firstname: 'Hilbert', lastname: 'Älg',
                           card_number: '1234-1234-1234-1234',
                           role: :user)
      attributes = { firstname: 'Helge', lastname: 'Älge',
                     card_number: '4321-4321-4321-4321',
                     role: :chairman }

      patch(:update, params: { id: user.to_param, user: attributes })
      user.reload

      response.should redirect_to(edit_admin_user_path(user))
      user.firstname.should eq('Helge')
      user.lastname.should eq('Älge')
      user.card_number.should eq('4321-4321-4321-4321')
      user.chairman?.should be_truthy
    end

    it 'invalid parameters' do
      user = create(:user, firstname: 'Hilbert', lastname: 'Älg',
                           card_number: '1234-1234-1234-1234')
      attributes = { firstname: '' }

      patch(:update, params: { id: user.to_param, user: attributes })
      user.reload

      response.status.should eq(422)
      response.should render_template(:edit)
      user.firstname.should eq('Hilbert')
    end
  end
end
