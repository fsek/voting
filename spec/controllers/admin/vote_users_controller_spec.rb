require 'rails_helper'

RSpec.describe Admin::VoteUsersController, type: :controller do
  let(:user) { create(:admin) }

  allow_user_to(:manage, User)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a vote user grid' do
      create(:user, firstname: 'First')
      create(:user, firstname: 'Second')
      create(:user, firstname: 'Third')

      get(:index)
      response.status.should eq(200)
      assigns(:vote_users_grid).should be_present
    end
  end

  describe 'GET #show' do
    it 'assigns given user as @user' do
      user = create(:user)

      get(:show, id: user.to_param)
      assigns(:user).should eq(user)
      assigns(:audit_grid).should be_present
    end
  end

  describe 'PATCH #present' do
    it 'makes not present @user present' do
      user = create(:user, presence: false)
      create(:vote, open: false)

      patch(:present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      response.should redirect_to(admin_vote_users_path)
      user.presence.should be_truthy
    end

    it 'makes already present @user stay present' do
      user = create(:user, presence: true)
      create(:vote, open: false)

      patch(:present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      response.should redirect_to(admin_vote_users_path)
      user.presence.should be_truthy
    end

    it 'doesnt work if a vote is open' do
      user = create(:user, presence: false)
      create(:vote, open: true)

      patch(:present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      user.presence.should be_falsey
      response.should redirect_to(admin_vote_users_path)
    end
  end

  describe 'PATCH #not_present' do
    it 'makes present @user not present' do
      user = create(:user, presence: true)
      create(:vote, open: false)

      patch(:not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      response.should redirect_to(admin_vote_users_path)
      flash[:notice].should eq(I18n.t('vote_user.state.made_not_present', u: user.to_s))
      user.presence.should be_falsey
    end

    it 'makes already not present @user stay not present' do
      user = create(:user, presence: false)
      create(:vote, open: false)

      patch(:not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      response.should redirect_to(admin_vote_users_path)
      flash[:notice].should eq(I18n.t('vote_user.state.made_not_present', u: user.to_s))
      user.presence.should be_falsey
    end

    it 'doesnt work if a vote is open' do
      user = create(:user, presence: true)
      create(:vote, open: true)

      patch(:not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      user.presence.should be_truthy
      flash[:alert].should eq(I18n.t('vote_user.state.error_not_present', u: user.to_s))
      response.should redirect_to(admin_vote_users_path)
    end
  end

  describe 'PATCH #all_not_present' do
    it 'sets all users to not present' do
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:vote, open: false)

      patch(:all_not_present)

      response.should redirect_to(admin_vote_users_path)
      flash[:notice].should eq(I18n.t('vote_user.state.all_not_present'))

      User.where(presence: true).count.should eq(0)
    end

    it 'does not set users to not present' do
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:vote, open: true)

      patch(:all_not_present)

      response.should redirect_to(admin_vote_users_path)
      flash[:alert].should eq(I18n.t('vote_user.state.error_all_not_present'))

      User.where(presence: true).count.should eq(4)
    end
  end

  describe 'PATCH #new_votecode' do
    it 'sets new votecode' do
      user = create(:user, votecode: 'abcd123')

      patch(:new_votecode, id: user)

      response.should redirect_to(admin_vote_users_path)
      user.reload
      user.votecode.should_not eq('abcd123')
    end

    it 'does not set new votecode' do
      user = create(:user, votecode: 'abcd123')
      allow(VoteService).to receive(:set_votecode) { false }

      patch(:new_votecode, id: user)

      response.status.should eq(422)
      response.should render_template(:show)

      user.reload
      user.votecode.should eq('abcd123')
    end
  end
end
