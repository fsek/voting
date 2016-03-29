require 'rails_helper'

RSpec.describe Admin::NoticesController, type: :controller do
  allow_user_to :manage, Notice

  describe 'GET #index' do
    it 'loads grid' do
      create(:notice, title: 'B')
      create(:notice, title: 'A')
      create(:notice, title: 'C')

      get(:index)

      response.should be_success
      assigns(:notice_grid).should be_present
    end
  end

  describe 'GET #new' do
    it 'succeeds' do
      get(:new)

      response.should be_success
      assigns(:notice).new_record?.should be_truthy
      assigns(:notice).instance_of?(Notice).should be_truthy
    end
  end

  describe 'GET #edit' do
    it 'succeeds' do
      notice = create(:notice)
      get(:edit, id: notice.to_param)

      response.should be_success
      assigns(:notice).should eq(notice)
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      attr = { title: 'Röstiga',
               public: true,
               description: 'Kontakta kontakta!',
               sort: 10 }

      lambda do
        post(:create, notice: attr)
      end.should change(Notice, :count).by(1)

      response.should redirect_to(edit_admin_notice_path(Notice.last))
      Notice.last.title.should eq('Röstiga')
    end

    it 'invalid params' do
      lambda do
        post(:create, notice: { title: nil })
      end.should change(Notice, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      notice = create(:notice, title: 'Valet inställt!')

      patch(:update, id: notice.to_param, notice: { title: 'Valet igång!' })
      notice.reload

      response.should redirect_to(edit_admin_notice_path(notice))
      notice.title.should eq('Valet igång!')
    end

    it 'invalid params' do
      notice = create(:notice, title: 'Valet bäst')

      patch(:update, id: notice.to_param, notice: { title: '' })
      notice.reload

      response.should render_template(:edit)
      response.status.should eq(422)
      notice.title.should eq('Valet bäst')
    end
  end

  describe 'DELETE #destroy' do
    it 'removes chosen ' do
      notice = create(:notice)

      lambda do
        delete(:destroy, id: notice.to_param)
      end.should change(Notice, :count).by(-1)

      response.should redirect_to(admin_notices_path)
    end
  end
end
