require 'rails_helper'

RSpec.describe Admin::ContactsController, type: :controller do
  allow_user_to :manage, Contact

  describe 'GET #index' do
    it 'orders by name' do
      create(:contact, name: 'B')
      create(:contact, name: 'A')
      create(:contact, name: 'C')

      get(:index)

      response.should be_success
      assigns(:contact_grid).should be_present
    end
  end

  describe 'GET #new' do
    it 'succeeds' do
      get(:new)

      response.should be_success
      assigns(:contact).new_record?.should be_truthy
      assigns(:contact).instance_of?(Contact).should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'succeeds' do
      contact = create(:contact)
      get(:edit, id: contact.to_param)

      response.should be_success
      assigns(:contact).should eq(contact)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      attr = { name: 'Röstiga',
               email: 'rostiga@fsektionen.se',
               text: 'Kontakta kontakta!' }

      lambda do
        post(:create, contact: attr)
      end.should change(Contact, :count).by(1)

      response.should redirect_to(admin_contact_path(Contact.last))
      Contact.last.name.should eq('Röstiga')
    end

    it 'invalid params' do
      lambda do
        post(:create, contact: { name: nil })
      end.should change(Contact, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      contact = create(:contact, name: 'Spindelman')

      patch(:update, id: contact.to_param, contact: { name: 'Röstiga' })
      contact.reload

      response.should redirect_to(edit_admin_contact_path(contact))
      contact.name.should eq('Röstiga')
    end

    it 'invalid params' do
      contact = create(:contact, name: 'Spindelman')

      patch(:update, id: contact.to_param, contact: { name: '' })
      contact.reload

      response.should render_template(:edit)
      response.status.should eq(422)
      contact.name.should eq('Spindelman')
    end
  end

  describe 'DELETE #destroy' do
    it 'removes chosen ' do
      contact = create(:contact)

      lambda do
        delete(:destroy, id: contact.to_param)
      end.should change(Contact, :count).by(-1)

      response.should redirect_to(admin_contacts_path)
    end
  end
end
