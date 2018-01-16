# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it 'can only have one open vote' do
      agenda = create(:agenda, status: :current)
      create(:vote, status: :open, agenda: agenda)
      vote = build(:vote, status: :open)
      vote.valid?

      vote.errors[:status].should include I18n.t('vote.already_one_open')
    end

    it 'updates present count on closing vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :open, agenda: agenda)
      vote.present_users.should equal 0

      vote.update(status: :closed)
      vote.present_users.should equal 2
    end

    it 'does not update present count on opening vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      agenda = create(:agenda, status: :current)
      vote = create(:vote, status: :future, agenda: agenda)
      vote.present_users.should equal 0

      vote.update(status: :open)
      vote.present_users.should equal 0
    end
  end
end
