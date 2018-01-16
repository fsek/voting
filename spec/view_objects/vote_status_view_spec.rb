# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VoteStatusView do
  describe 'initialisation' do
    it 'sets current' do
      agenda = create(:agenda, status: :current)
      create(:agenda, status: :closed)
      vote = create(:vote, status: :open, agenda: agenda)
      create(:vote, status: :closed)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: true)
      create(:user, presence: false)

      vote_status = VoteStatusView.new
      vote_status.agenda.should eq(agenda)
      vote_status.vote.should eq(vote)
    end
  end
end
