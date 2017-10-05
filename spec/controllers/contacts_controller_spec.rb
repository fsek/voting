require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  allow_user_to %i(index mail), :contact

  describe 'GET #index' do
    it 'succeeds and assigns contacts' do
      get :index
      response.should be_success
    end
  end

  describe 'POST #mail' do
    it 'valid params' do
      attributes = { name: 'David',
                     email: 'david@google.com',
                     message: 'Jag vill prova kontaktformuläret' }
      post :mail, message: attributes
      response.should redirect_to(contacts_path)
    end

    it 'invalid params' do
      attributes = { name: 'David',
                     email: 'inte_en_epost',
                     message: 'Jag vill prova kontaktformuläret' }
      post :mail, message: attributes

      response.status.should eq(422)
      response.should render_template(:index)
    end
  end
end
