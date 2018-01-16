# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AgendasController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Agenda)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'shows all agendas' do
      create(:agenda, title: 'First')
      create(:agenda, title: 'Second')
      create(:agenda, title: 'Third')

      get(:index)
      response.status.should eq(200)
    end
  end

  describe 'GET #edit' do
    it 'assigns given agenda as @agenda' do
      agenda = create(:agenda)

      get(:edit, params: { id: agenda.to_param })
      response.status.should eq(200)
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
                     index: 10,
                     short: 'Bifall',
                     description: '## Waow' }

      lambda do
        post(:create, params: { agenda: attributes })
      end.should change(Agenda, :count).by(1)

      response.should redirect_to(new_admin_agenda_path)
      Agenda.last.title.should eq('Propositioner')
    end

    it 'invalid parameters' do
      lambda do
        post(:create, params: { agenda: { title: '' } })
      end.should change(Agenda, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      agenda = create(:agenda, title: 'A Bad Title')

      patch(:update, params: { id: agenda.to_param,
                               agenda: { title: 'A Good Title' } })
      agenda.reload

      response.should redirect_to(edit_admin_agenda_path(agenda))
      agenda.title.should eq('A Good Title')
    end

    it 'invalid parameters' do
      agenda = create(:agenda, title: 'A Bad Title')

      patch(:update, params: { id: agenda.to_param,
                               agenda: { title: '' } })
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
        delete(:destroy, params: { id: agenda.to_param })
      end.should change(Agenda, :count).by(-1)

      agenda.reload
      agenda.deleted?.should be_truthy

      response.should redirect_to(admin_agendas_path)
    end

    it 'fails if the agenda is current' do
      agenda = create(:agenda, status: :current)

      lambda do
        delete(:destroy, params: { id: agenda.to_param })
      end.should_not change(Agenda, :count)

      agenda.reload
      agenda.deleted?.should be_falsey

      response.should redirect_to(admin_agendas_path)
      flash[:alert].should eq(I18n.t('agenda.error_deleting'))
    end

    it 'fails if the agenda has a current child' do
      agenda = create(:agenda)
      child = create(:agenda, status: :current, parent: agenda)

      lambda do
        delete(:destroy, params: { id: agenda.to_param })
      end.should_not change(Agenda, :count)

      agenda.reload
      child.reload
      agenda.deleted?.should be_falsey
      child.deleted?.should be_falsey

      response.should redirect_to(admin_agendas_path)
      flash[:alert].should eq(I18n.t('agenda.error_deleting'))
    end

    it 'fails if the agenda has a current grandchild' do
      agenda = create(:agenda)
      child = create(:agenda, parent: agenda)
      grandchild = create(:agenda, status: :current, parent: child)

      lambda do
        delete(:destroy, params: { id: agenda.to_param })
      end.should_not change(Agenda, :count)

      agenda.reload
      child.reload
      grandchild.reload

      agenda.deleted?.should be_falsey
      child.deleted?.should be_falsey
      grandchild.deleted?.should be_falsey

      response.should redirect_to(admin_agendas_path)
      flash[:alert].should eq(I18n.t('agenda.error_deleting'))
    end

    it 'works if the agenda has non-current children' do
      agenda = create(:agenda)
      child1 = create(:agenda, parent: agenda)
      child2 = create(:agenda, status: :closed, parent: agenda)
      grandchild = create(:agenda, parent: child2)

      lambda do
        delete(:destroy, params: { id: agenda.to_param })
      end.should change(Agenda, :count).by(-4)

      agenda.reload
      child1.reload
      child2.reload
      grandchild.reload

      agenda.deleted?.should be_truthy
      child1.deleted?.should be_truthy
      child2.deleted?.should be_truthy
      grandchild.deleted?.should be_truthy

      response.should redirect_to(admin_agendas_path)
      flash[:notice].should eq(I18n.t('agenda.deleted_ok'))
    end
  end
end
