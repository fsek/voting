require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it 'can only have one open vote' do
      agenda = create(:agenda, status: :current)
      create(:vote, status: Vote::OPEN, agenda: agenda)
      vote = build(:vote, status: Vote::OPEN)
      vote.valid?

      vote.errors[:status].should include I18n.t('vote.already_one_open')
    end

    it 'updates present count on closing vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: Vote::OPEN, agenda: agenda)
      vote.present_users.should equal 0

      vote.update(status: Vote::CLOSED)
      vote.present_users.should equal 2
    end

    it 'does not update present count on opening vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: Vote::FUTURE, agenda: agenda)
      vote.present_users.should equal 0

      vote.update(status: Vote::OPEN)
      vote.present_users.should equal 0
    end
  end
end
