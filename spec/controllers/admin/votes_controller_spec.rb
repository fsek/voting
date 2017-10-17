require 'rails_helper'

RSpec.describe Admin::VotesController, type: :controller do
  let(:user) { create(:user, :admin) }

  allow_user_to(:manage, Vote)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'render vote index' do
      create(:vote, title: 'Second vote')
      create(:vote, title: 'First vote')
      create(:vote, title: 'Third vote')

      get(:index)
      response.should have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'shows vote' do
      vote = create(:vote)

      get(:show, params: { id: vote.to_param })
      response.should have_http_status(200)
    end
  end

  describe 'GET #edit' do
    it 'edits vote' do
      vote = create(:vote)

      get(:edit, params: { id: vote.to_param })
      response.should have_http_status(200)
    end

    it 'works if the vote is closed' do
      vote = create(:vote, status: :closed)

      get(:edit, params: { id: vote.to_param })
      response.should have_http_status(200)
    end

    it 'works if the vote is future' do
      vote = create(:vote, status: :future)

      get(:edit, params: { id: vote.to_param })
      response.should have_http_status(200)
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :open, agenda: agenda)

      get(:edit, params: { id: vote.to_param })

      flash[:alert].should eq(I18n.t('vote.cannot_edit'))
      response.should redirect_to(admin_votes_path)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get(:new)
      response.should have_http_status(200)
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      option_attr = { '12345678': { title: 'Joost' } }
      attributes = { title: 'Ordförande',
                     vote_options_attributes: option_attr }

      lambda do
        post(:create, params: { vote: attributes })
      end.should change(Vote, :count).by(1)

      response.should redirect_to(edit_admin_vote_path(Vote.last))
      Vote.last.vote_options.map(&:title).should eq(['Joost'])
    end

    it 'invalid parameters' do
      lambda do
        post(:create, params: { vote: { title: '' } })
      end.should change(Vote, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end

  describe 'PATCH #update' do
    it 'valid parameters and future vote' do
      vote = create(:vote, title: 'A Bad Title')

      patch(:update, params: { id: vote.to_param,
                               vote: { title: 'A Good Title' } })
      vote.reload

      vote.title.should eq('A Good Title')
      response.should redirect_to(edit_admin_vote_path(vote))
    end

    it 'valid parameters and closed vote' do
      vote = create(:vote, title: 'A Bad Title', status: :closed)

      patch(:update, params: { id: vote.to_param,
                               vote: { title: 'A Good Title' } })
      vote.reload

      vote.title.should eq('A Good Title')
      response.should redirect_to(edit_admin_vote_path(vote))
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, title: 'A Bad Title', status: :open, agenda: agenda)

      patch(:update, params: { id: vote.to_param,
                               vote: { title: 'A Good Title' } })
      vote.reload

      vote.title.should eq('A Bad Title')
      flash[:alert].should eq(I18n.t('vote.cannot_edit'))
      response.should redirect_to(admin_votes_path)
    end

    it 'invalid parameters' do
      vote = create(:vote, title: 'A Bad Title')

      patch(:update, params: { id: vote.to_param,
                               vote: { title: '' } })
      vote.reload

      response.should have_http_status(422)
      response.should render_template(:edit)
      vote.title.should eq('A Bad Title')
    end
  end

  describe 'DELETE #destroy' do
    it 'valid parameters' do
      vote = create(:vote)

      lambda do
        delete(:destroy, params: { id: vote.to_param })
      end.should change(Vote, :count).by(-1)

      response.should redirect_to(admin_votes_path)
    end
  end
end
