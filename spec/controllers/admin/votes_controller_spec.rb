require 'rails_helper'

RSpec.describe Admin::VotesController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Vote)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'assigns a vote grid' do
      create(:vote, title: 'Second vote')
      create(:vote, title: 'First vote')
      create(:vote, title: 'Third vote')

      get(:index)
      response.status.should eq(200)
      assigns(:votes_grid).should be_present
    end
  end

  describe 'GET #show' do
    it 'assigns given vote as @vote' do
      vote = create(:vote)

      get(:show, id: vote.to_param)
      assigns(:vote).should eq(vote)
      assigns(:audit_grid).should be_present
    end
  end

  describe 'GET #edit' do
    it 'assigns given vote as @vote' do
      vote = create(:vote)

      get(:edit, id: vote.to_param)
      assigns(:vote).should eq(vote)
    end

    it 'works if the vote is closed' do
      vote = create(:vote, status: Vote::CLOSED)

      get(:edit, id: vote.to_param)
      assigns(:vote).should eq(vote)
      response.status.should eq(200)
    end

    it 'works if the vote is future' do
      vote = create(:vote, status: Vote::FUTURE)

      get(:edit, id: vote.to_param)
      assigns(:vote).should eq(vote)
      response.status.should eq(200)
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)

      get(:edit, id: vote.to_param)

      assigns(:vote).should eq(vote)
      flash[:alert].should eq(I18n.t('vote.cannot_edit'))
      response.should redirect_to(admin_votes_path)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vote as @vote' do
      get(:new)
      assigns(:vote).instance_of?(Vote).should be_truthy
      assigns(:vote).new_record?.should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      option_attr = { '12345678': { title: 'Joost' } }
      attributes = { title: 'Ordförande',
                     vote_options_attributes: option_attr }

      lambda do
        post :create, vote: attributes
      end.should change(Vote, :count).by(1)

      response.should redirect_to(edit_admin_vote_path(Vote.last))
      Vote.last.vote_options.map(&:title).should eq(['Joost'])
    end

    it 'invalid parameters' do
      lambda do
        post :create, vote: { title: '' }
      end.should change(Vote, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters and future vote' do
      vote = create(:vote, title: 'A Bad Title')

      patch :update, id: vote.to_param, vote: { title: 'A Good Title' }
      vote.reload

      vote.title.should eq('A Good Title')
      response.should redirect_to(edit_admin_vote_path(vote))
    end

    it 'valid parameters and closed vote' do
      vote = create(:vote, title: 'A Bad Title', status: Vote::CLOSED)

      patch :update, id: vote.to_param, vote: { title: 'A Good Title' }
      vote.reload

      vote.title.should eq('A Good Title')
      response.should redirect_to(edit_admin_vote_path(vote))
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, title: 'A Bad Title', status: Vote::OPEN, agenda: agenda)

      patch :update, id: vote.to_param, vote: { title: 'A Good Title' }
      vote.reload

      vote.title.should eq('A Bad Title')
      flash[:alert].should eq(I18n.t('vote.cannot_edit'))
      response.should redirect_to(admin_votes_path)
    end

    it 'invalid parameters' do
      vote = create(:vote, title: 'A Bad Title')

      patch :update, id: vote.to_param, vote: { title: '' }
      vote.reload

      response.status.should eq(422)
      response.should render_template(:edit)
      vote.title.should eq('A Bad Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      vote = create(:vote)

      lambda do
        delete :destroy, id: vote.to_param
      end.should change(Vote, :count).by(-1)

      response.should redirect_to(admin_votes_path)
    end
  end

  describe 'PATCH #open' do
    it 'opens the vote default to index' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::FUTURE, agenda: agenda)

      patch(:open, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:notice].should eq(I18n.t('vote.made_open'))
      vote.reload
      vote.open?.should be_truthy
    end

    it 'opens the vote with route show' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::FUTURE, agenda: agenda)

      patch(:open, id: vote, route: :show)

      response.should redirect_to(admin_vote_path(vote))
      flash[:notice].should eq(I18n.t('vote.made_open'))
      vote.reload
      vote.open?.should be_truthy
    end

    it 'cannot open the vote if another vote is open' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:vote, status: Vote::OPEN, agenda: agenda)
      vote = create(:vote, status: Vote::FUTURE, agenda: agenda)

      patch(:open, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:alert].should eq(I18n.t('vote.already_one_open'))
      vote.reload
      vote.open?.should be_falsey
    end

    it 'cannot open the vote on the wrong agenda' do
      create(:agenda, status: Agenda::CURRENT)
      agenda = create(:agenda, status: Agenda::FUTURE)
      vote = create(:vote, status: Vote::FUTURE, agenda: agenda)

      patch(:open, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:alert].should eq(I18n.t('vote.wrong_agenda'))
      vote.reload
      vote.open?.should be_falsey
    end
  end

  describe 'PATCH #close' do
    it 'closes the vote' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)

      patch(:close, id: vote)

      response.should redirect_to(admin_votes_path)
      flash[:notice].should eq(I18n.t('vote.made_closed'))
      vote.reload
      vote.open?.should be_falsey
    end
  end

  describe 'PATCH #reset' do
    it 'resets the vote' do
      vote = create(:vote, status: Vote::CLOSED)
      create(:vote_option, vote: vote, count: 1)
      create(:vote_option, vote: vote, count: 1)
      create(:vote_post, vote: vote)
      create(:vote_post, vote: vote)

      vote.vote_options.sum(:count).should eq 2
      vote.vote_posts.count.should eq 2

      patch(:reset, id: vote)

      response.should redirect_to(admin_vote_path(vote))
      flash[:notice].should eq(I18n.t('vote.reset_ok'))
      vote.reload
      vote.vote_options.sum(:count).should eq 0
      vote.vote_posts.count.should eq 0
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)
      create(:vote_option, vote: vote, count: 1)
      create(:vote_option, vote: vote, count: 1)
      create(:vote_post, vote: vote)
      create(:vote_post, vote: vote)

      vote.vote_options.sum(:count).should eq 2
      vote.vote_posts.count.should eq 2

      patch(:reset, id: vote)

      response.should redirect_to(admin_vote_path(vote))
      flash[:alert].should eq(I18n.t('vote.cannot_reset'))
      vote.reload
      vote.vote_options.sum(:count).should eq 2
      vote.vote_posts.count.should eq 2
    end
  end
end
