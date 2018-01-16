# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotePostsController, type: :controller do
  let(:user) { create(:user) }

  allow_user_to(:manage, VotePost)

  before(:each) do
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #new' do
    it 'sets new vote_post if post is open' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :open, agenda: agenda)

      get(:new, params: { vote_id: vote })

      assigns(:vote).should eq(vote)
      assigns(:vote_post).new_record?.should be_truthy
      assigns(:vote_post).instance_of?(VotePost).should be_truthy
      response.status.should eq(200)
    end

    it 'redirects if vote is closed' do
      vote = create(:vote, status: :closed)

      get(:new, params: { vote_id: vote })

      assigns(:vote).should eq(vote)
      response.should redirect_to(votes_path)
      flash[:alert].should eq(I18n.t('vote.is_closed'))
    end

    it 'redirects if vote is future' do
      vote = create(:vote, status: :future)

      get(:new, params: { vote_id: vote })

      assigns(:vote).should eq(vote)
      response.should redirect_to(votes_path)
      flash[:alert].should eq(I18n.t('vote.is_closed'))
    end
  end

  describe 'POST #create' do
    it 'valid parameters' do
      agenda = create(:agenda, status: :current)
      user.update!(presence: true, votecode: 'abcd123')
      vote = create(:vote, :with_options, status: :open, agenda: agenda)
      attributes = { votecode: 'abcd123',
                     vote_option_ids: [vote.vote_options.first.id] }

      lambda do
        post(:create, params: { vote_id: vote.to_param, vote_post: attributes })
      end.should change(VotePost, :count).by(1)

      response.should redirect_to(votes_path)
    end

    it 'allows blank votes' do
      user.update!(presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open, agenda: agenda)
      attributes = { votecode: 'abcd123' }

      lambda do
        post(:create, params: { vote_id: vote.to_param, vote_post: attributes })
      end.should change(VotePost, :count).by(1)

      response.should redirect_to(votes_path)
    end

    it 'invalid parameters' do
      user.update!(presence: true, votecode: 'abcd123')
      agenda = create(:agenda, status: :current)
      vote = create(:vote, :with_options, status: :open, agenda: agenda)
      attributes = { votecode: 'falseyfalsey',
                     vote_option_ids: [vote.vote_options.first.id] }

      lambda do
        post(:create, params: { vote_id: vote.to_param, vote_post: attributes })
      end.should change(VotePost, :count).by(0)

      response.status.should eq(422)
      response.should render_template(:new)
    end
  end
end
