# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations' do
    it 'can only have one open vote' do
      sub_item = create(:sub_item, status: :current)
      create(:vote, status: :open, sub_item: sub_item)
      vote = build(:vote, status: :open)
      vote.valid?

      vote.errors[:status].should include I18n.t('model.vote.already_one_open')
    end

    it 'updates present count on closing vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :open, sub_item: sub_item)
      vote.present_users.should equal 0

      vote.update(status: :closed)
      vote.present_users.should equal 2
    end

    it 'does not update present count on opening vote' do
      create(:user, presence: true)
      create(:user, presence: true)
      sub_item = create(:sub_item, status: :current)
      vote = create(:vote, status: :future, sub_item: sub_item)
      vote.present_users.should equal 0

      vote.update(status: :open)
      vote.present_users.should equal 0
    end
  end
end
