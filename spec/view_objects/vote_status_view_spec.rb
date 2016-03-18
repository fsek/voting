require 'rails_helper'

RSpec.describe VoteStatusView do
  describe 'initialisation' do
    it 'sets current' do
      agenda = create(:agenda, status: Agenda::CURRENT)
      create(:agenda, status: Agenda::CLOSED)
      vote = create(:vote, open: true)
      create(:vote, open: false)
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
