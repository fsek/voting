require 'rails_helper'

RSpec.describe Admin::AdjustmentsController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Adjustment)
  allow_user_to(:manage_voting, User)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns an agenda' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)

      get(:index)
      response.status.should eq(200)
      assigns(:vote_status_view).agenda.should eq(agenda)
      assigns(:vote_status_view).vote.should eq(vote)
    end
  end

  describe 'GET #new' do
    it 'assigns new adjustment with user' do
      user = create(:user)

      get(:new, user_id: user.to_param)
      assigns(:adjustment).instance_of?(Adjustment).should be_truthy
      assigns(:adjustment).new_record?.should be_truthy
      assigns(:adjustment).user.should eq(user)
    end
  end

  describe 'GET #edit' do
    it 'assigns given adjustment as @adjustment' do
      adjustment = create(:adjustment)

      get(:edit, id: adjustment.to_param)
      assigns(:adjustment).should eq(adjustment)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      user = create(:user)
      attributes = { agenda_id: agenda.to_param,
                     user_id: user.to_param,
                     presence: true }

      lambda do
        post :create, adjustment: attributes
      end.should change(Adjustment, :count).by(1)

      response.should redirect_to(admin_vote_user_path(user.to_param))
    end

    it 'invalid parameters' do
      lambda do
        post :create, adjustment: { presence: false }
      end.should change(Adjustment, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters' do
      adjustment = create(:adjustment, presence: true)

      patch :update, id: adjustment.to_param, adjustment: { presence: false }
      adjustment.reload

      response.should redirect_to(edit_admin_adjustment_path(adjustment))
      adjustment.presence.should be_falsey
    end

    it 'invalid parameters' do
      user = create(:user)
      adjustment = create(:adjustment, user: user, presence: true)

      patch :update, id: adjustment.to_param, adjustment: { user_id: nil }
      adjustment.reload

      response.status.should eq(422)
      response.should render_template(:edit)
      adjustment.user.should eq(user)
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      user = create(:user)
      adjustment = create(:adjustment, user: user)

      lambda do
        delete :destroy, id: adjustment.to_param
      end.should change(Adjustment, :count).by(-1)

      response.status.should eq(200)
    end
  end

  describe 'POST #update_row_order' do
    it 'moves the last adjustment to the top' do
      user = create(:user)
      a1 = create(:adjustment, user: user)
      a2 = create(:adjustment, user: user)
      a3 = create(:adjustment, user: user)

      get(:update_row_order, id: a3.to_param, adjustment: { row_order_position: 0 })
      response.status.should eq(200)

      user.adjustments.rank(:row_order).should eq [a3, a1, a2]
    end
  end
end
