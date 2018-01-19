# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoteStatusView do
  describe 'initialisation' do
    it 'sets current' do
      sub_item = create(:sub_item, status: :current)
      create(:sub_item, status: :closed)
      vote = create(:vote, status: :open, sub_item: sub_item)
      create(:vote, status: :closed)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: false)

      vote_status = VoteStatusView.new
      vote_status.sub_item.should eq(sub_item)
      vote_status.vote.should eq(vote)
    end
  end
end
