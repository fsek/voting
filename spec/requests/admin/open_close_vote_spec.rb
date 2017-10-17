# frozen_string_literal: true

require 'rails_helper'

RSpec.describe("Open close reset votes", type: :request) do
  before(:each) do
    sign_in(create(:user, role: :chairman))
  end

  describe 'opening' do
    it 'opens the vote default to index' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :future, agenda: agenda)

      post(admin_vote_opening_path(vote))

      expect(response).to redirect_to(admin_votes_path)
      vote.reload
      expect(vote.open?).to be_truthy
    end

    it 'opens the vote with route show' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :future, agenda: agenda)

      post(admin_vote_opening_path(vote),
           headers: { 'HTTP_REFERER': admin_vote_path(vote) })

      expect(response).to redirect_to(admin_vote_path(vote))
      vote.reload
      expect(vote.open?).to be_truthy
    end

    it 'cannot open the vote if another vote is open' do
      agenda = create(:agenda, status: :current)
      create(:vote, status: :open, agenda: agenda)
      vote = create(:vote, status: :future, agenda: agenda)

      post(admin_vote_opening_path(vote))

      expect(response).to redirect_to(admin_votes_path)
      vote.reload
      expect(vote.open?).to be_falsey
    end

    it 'cannot open the vote on the wrong agenda' do
      create(:agenda, status: :current)
      agenda = create(:agenda, status: :future)
      vote = create(:vote, status: :future, agenda: agenda)

      post(admin_vote_opening_path(vote))

      expect(response).to redirect_to(admin_votes_path)
      vote.reload
      expect(vote.open?).to be_falsey
    end
  end

  it 'closes the vote' do
    agenda = create(:agenda, status: :current)
    vote = create(:vote, status: :open, agenda: agenda)

    delete(admin_vote_opening_path(vote))

    expect(response).to redirect_to(admin_votes_path)
    vote.reload
    expect(vote.open?).to be_falsey
  end

  describe 'PATCH #reset' do
    it 'resets the vote' do
      vote = create(:vote, status: :closed)
      create_list(:vote_option, 2, vote: vote, count: 1)
      create_list(:vote_post, 2, vote: vote)

      expect(vote.vote_options.sum(:count)).to eq(2)
      expect(vote.vote_posts.count).to eq(2)

      post(admin_vote_reset_path(vote))

      expect(response).to redirect_to(admin_vote_path(vote))
      vote.reload
      expect(vote.vote_options.sum(:count)).to eq(0)
      expect(vote.vote_posts.count).to eq(0)
    end

    it 'fails if the vote is open' do
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :open, agenda: agenda)
      create_list(:vote_option, 2, vote: vote, count: 1)
      create_list(:vote_post, 2, vote: vote)

      expect(vote.vote_options.sum(:count)).to eq(2)
      expect(vote.vote_posts.count).to eq(2)

      post(admin_vote_reset_path(vote))

      response.should redirect_to(admin_vote_path(vote))
      vote.reload
      expect(vote.vote_options.sum(:count)).to eq(2)
      expect(vote.vote_posts.count).to eq(2)
    end
  end
end
