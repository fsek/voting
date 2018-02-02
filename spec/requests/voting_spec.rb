# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Voting', type: :request) do
  let(:user) { create(:user, role: :user) }

  it 'requires being signed in' do
    sub_item = create(:sub_item, status: :current)
    vote = create(:vote, status: :open, sub_item: sub_item)
    get(vote_vote_posts_path(vote))
    expect(response).to redirect_to(new_user_session_path)
  end

  describe 'view vote_post' do
    it 'works if vote is open' do
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :open, sub_item: sub_item)
      sign_in(user)

      get(vote_vote_posts_path(vote))
      expect(response).to have_http_status(200)
    end

    it 'redirects if closed' do
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :closed, sub_item: sub_item)
      sign_in(user)

      get(vote_vote_posts_path(vote))
      expect(response).to redirect_to(votes_path)
    end

    it 'redirects if future' do
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :future, sub_item: sub_item)
      sign_in(user)

      get(vote_vote_posts_path(vote))
      expect(response).to redirect_to(votes_path)
    end
  end

  describe 'create vote_post' do
    it 'valid parameters' do
      sub_item = create(:sub_item, status: :current)
      user.update!(presence: true, votecode: 'abcd123')
      vote = create(:vote, :with_options, status: :open, sub_item: sub_item)
      attributes = { votecode: 'abcd123',
                     vote_option_ids: [vote.vote_options.first.id] }
      sign_in(user)

      expect do
        post(vote_vote_posts_path(vote), params: { vote_post: attributes })
      end.to change(VotePost, :count).by(1)

      expect(response).to redirect_to(votes_path)
    end

    it 'allows blank votes' do
      user.update!(presence: true, votecode: 'abcd123')
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, :with_options, status: :open, sub_item: sub_item)
      attributes = { votecode: 'abcd123' }
      sign_in(user)

      expect do
        post(vote_vote_posts_path(vote), params: { vote_post: attributes })
      end.to change(VotePost, :count).by(1)

      response.should redirect_to(votes_path)
    end

    it 'invalid parameters' do
      user.update!(presence: true, votecode: 'abcd123')
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, :with_options, status: :open, sub_item: sub_item)
      attributes = { votecode: 'falseyfalsey',
                     vote_option_ids: [vote.vote_options.first.id] }

      sign_in(user)

      expect do
        post(vote_vote_posts_path(vote), params: { vote_post: attributes })
      end.to change(VotePost, :count).by(0)

      expect(response).to have_http_status(422)
    end
  end
end
