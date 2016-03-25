require 'rails_helper'

RSpec.describe Admin::VoteUsersController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, :vote_user)

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
      create(:vote, status: Vote::FUTURE)
      create(:agenda, status: Agenda::CURRENT)

      xhr(:patch, :present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_truthy
      user.presence.should be_truthy
    end

    it 'makes already present @user stay present' do
      user = create(:user, presence: true)
      create(:vote, status: Vote::FUTURE)
      create(:agenda, status: Agenda::CURRENT)

      xhr(:patch, :present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_truthy
      user.presence.should be_truthy
    end

    it 'doesnt work if a vote is open' do
      user = create(:user, presence: false)
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)

      xhr(:patch, :present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_falsey
      user.presence.should be_falsey
    end

    it 'doesnt work without a current agenda' do
      user = create(:user, presence: false)
      create(:vote, status: Vote::FUTURE)
      create(:agenda)

      xhr(:patch, :present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_falsey
      user.presence.should be_falsey
    end
  end

  describe 'PATCH #not_present' do
    it 'makes present @user not present' do
      user = create(:user, presence: true)
      create(:vote, status: Vote::FUTURE)
      create(:agenda, status: Agenda::CURRENT)

      xhr(:patch, :not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_truthy
      user.presence.should be_falsey
    end

    it 'makes already not present @user stay not present' do
      user = create(:user, presence: false)
      create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::FUTURE)

      xhr(:patch, :not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_truthy
      user.presence.should be_falsey
    end

    it 'doesnt work if a vote is open' do
      user = create(:user, presence: true)
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)

      xhr(:patch, :not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_falsey
      user.presence.should be_truthy
    end

    it 'doesnt work without a current agenda' do
      user = create(:user, presence: true)
      create(:agenda)
      create(:vote, status: Vote::FUTURE)

      xhr(:patch, :not_present, id: user.to_param)

      user.reload
      assigns(:user).should eq(user)
      assigns(:success).should be_falsey
      user.presence.should be_truthy
    end
  end

  describe 'PATCH #all_not_present' do
    it 'sets all users to not present' do
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:vote, status: Vote::FUTURE)
      create(:agenda, status: Agenda::CURRENT)

      patch(:all_not_present)

      response.should redirect_to(admin_vote_users_path)
      flash[:notice].should eq(I18n.t('vote_user.state.all_not_present'))

      User.where(presence: true).count.should eq(0)
    end

    it 'does not set users to not present if a vote is open' do
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)

      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)

      patch(:all_not_present)

      response.should redirect_to(admin_vote_users_path)
      flash[:alert].should eq(I18n.t('vote_user.state.error_all_not_present'))

      User.where(presence: true).count.should eq(4)
    end

    it 'does not set users to not present without a current agenda' do
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:agenda)

      patch(:all_not_present)

      response.should redirect_to(admin_vote_users_path)
      flash[:alert].should eq(I18n.t('vote_user.state.error_all_not_present'))

      User.where(presence: true).count.should eq(4)
    end
  end

  describe 'PATCH #new_votecode' do
    it 'sets new votecode' do
      user = create(:user, votecode: 'abcd123')

      xhr(:patch, :new_votecode, id: user)

      user.reload
      user.votecode.should_not eq('abcd123')
      assigns(:user).should eq(user)
      assigns(:success).should be_truthy
    end

    it 'does not set new votecode' do
      user = create(:user, votecode: 'abcd123')
      allow(VoteService).to receive(:set_votecode) { false }

      xhr(:patch, :new_votecode, id: user)

      user.reload
      user.votecode.should eq('abcd123')
      assigns(:user).should eq(user)
      assigns(:success).should be_falsey
    end
  end

  describe 'POST #search' do
    it 'finds user with card number' do
      create(:user, firstname: 'The one', card_number: '1234-1234-1234-1234')
      create(:user, firstname: 'Not the one', card_number: '4321-4321-4321-4321')

      xhr(:post, :search, vote_user: { card_number: '1234-1234-1234-1234' })
      assigns(:vote_users).map(&:firstname).should eq(['The one'])
    end
  end
end
