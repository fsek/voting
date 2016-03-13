require 'rails_helper'

RSpec.describe Admin::AgendasController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Agenda)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a agenda grid' do
      create(:agenda, title: 'First')
      create(:agenda, title: 'Second')
      create(:agenda, title: 'Third')

      get(:index)
      response.status.should eq(200)
      assigns(:agenda_grid).should be_present
    end
  end

  describe 'GET #edit' do
    it 'assigns given agenda as @agenda' do
      agenda = create(:agenda)

      get(:edit, id: agenda.to_param)
      assigns(:agenda).should eq(agenda)
    end
  end

  describe 'GET #new' do
    it 'assigns a new agenda as @agenda' do
      get(:new)
      assigns(:agenda).instance_of?(Agenda).should be_truthy
      assigns(:agenda).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      attributes = { title: 'Propositioner',
                     index: 10 }

      lambda do
        post :create, agenda: attributes
      end.should change(Agenda, :count).by(1)

      response.should redirect_to(new_admin_agenda_path)
      Agenda.last.title.should eq('Propositioner')
    end

    it 'invalid parameters' do
      lambda do
        post :create, agenda: { title: '' }
      end.should change(Agenda, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      agenda = create(:agenda, title: 'A Bad Title')

      patch :update, id: agenda.to_param, agenda: { title: 'A Good Title' }
      agenda.reload

      response.should redirect_to(edit_admin_agenda_path(agenda))
      agenda.title.should eq('A Good Title')
    end

    it 'invalid parameters' do
      agenda = create(:agenda, title: 'A Bad Title')

      patch :update, id: agenda.to_param, agenda: { title: '' }
      agenda.reload

      response.status.should eq(422)
      response.should render_template(:edit)
      agenda.title.should eq('A Bad Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      agenda = create(:agenda)

      lambda do
        delete :destroy, id: agenda.to_param
      end.should change(Agenda, :count).by(-1)

      response.should redirect_to(admin_agendas_path)
    end
  end

  describe 'PATCH #set_current' do
    it 'makes closed @agenda current' do
      agenda = create(:agenda, status: Agenda::CLOSED)

      xhr(:patch, :set_current, id: agenda.to_param)

      agenda.reload
      assigns(:agenda).should eq(agenda)
      assigns(:success).should be_truthy
      agenda.status.should eq(Agenda::CURRENT)
      Agenda.current.should eq(agenda)
    end

    it 'doesnt work if there already is a current agenda' do
      current_agenda = create(:agenda, status: Agenda::CURRENT)
      agenda = create(:agenda, status: Agenda::CLOSED)

      xhr(:patch, :set_current, id: agenda.to_param)

      agenda.reload
      assigns(:agenda).should eq(agenda)
      assigns(:success).should be_falsey
      Agenda.current.should eq(current_agenda)
    end
  end

  describe 'PATCH #set_closed' do
    it 'makes current @agenda closed' do
      agenda = create(:agenda, status: Agenda::CURRENT)

      xhr(:patch, :set_closed, id: agenda.to_param)

      agenda.reload
      assigns(:agenda).should eq(agenda)
      assigns(:success).should be_truthy
      agenda.status.should eq(Agenda::CLOSED)
      Agenda.current.should be_nil
    end
  end
end
