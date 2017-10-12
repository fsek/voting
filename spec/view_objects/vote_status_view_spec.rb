require 'rails_helper'

RSpec.describe VoteStatusView do
  describe 'initialisation' do
    it 'sets current' do
      agenda = create(:agenda, status: :current)
      create(:agenda, status: :closed)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)
      create(:vote, status: Vote::CLOSED)
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
